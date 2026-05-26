/*
 * screencap.c - Capture a terminal window to PNG
 *
 * Usage:
 *   screencap                     # capture own terminal (WINDOWID)
 *   screencap -t "title"          # capture window matching title substring
 *   screencap -t "title" /outdir  # same, save to /outdir
 *   screencap /outdir             # capture own terminal, save to /outdir
 *
 * Build:
 *   gcc -DSCREENCAP_STANDALONE -o screencap screencap.c -lX11 -lpng
 */

#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>
#include <png.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <ctype.h>

static void sanitizeFilename(char *dst, const char *src, int maxlen) {
    int j = 0;
    for (int i = 0; src[i] && j < maxlen - 1; i++) {
        char c = src[i];
        if (isalnum(c) || c == '-' || c == '_' || c == '.')
            dst[j++] = c;
        else if (c == ' ')
            dst[j++] = '_';
    }
    dst[j] = '\0';
}

static int writePng(const char *path, unsigned char *pixels, int w, int h) {
    FILE *fp = fopen(path, "wb");
    if (!fp) return -1;

    png_structp png = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
    png_infop info = png_create_info_struct(png);
    if (setjmp(png_jmpbuf(png))) {
        png_destroy_write_struct(&png, &info);
        fclose(fp);
        return -1;
    }

    png_init_io(png, fp);
    png_set_IHDR(png, info, w, h, 8, PNG_COLOR_TYPE_RGB,
                 PNG_INTERLACE_NONE, PNG_COMPRESSION_TYPE_DEFAULT,
                 PNG_FILTER_TYPE_DEFAULT);
    png_write_info(png, info);

    png_bytep *rows = malloc(h * sizeof(png_bytep));
    for (int y = 0; y < h; y++)
        rows[y] = pixels + y * w * 3;

    png_write_image(png, rows);
    png_write_end(png, NULL);
    free(rows);
    png_destroy_write_struct(&png, &info);
    fclose(fp);
    return 0;
}

/* Recursively search for a window whose title exactly matches */
static Window findByTitle(Display *dpy, Window parent, const char *needle) {
    XTextProperty prop;
    if (XGetWMName(dpy, parent, &prop) && prop.value) {
        if (strcmp((char *)prop.value, needle) == 0)
            return parent;
    }

    Window root_ret, parent_ret, *children = NULL;
    unsigned int nchildren = 0;
    if (!XQueryTree(dpy, parent, &root_ret, &parent_ret, &children, &nchildren))
        return 0;

    Window found = 0;
    for (unsigned int i = 0; i < nchildren && !found; i++)
        found = findByTitle(dpy, children[i], needle);

    if (children) XFree(children);
    return found;
}

/* Walk up from a tiny child to find the real top-level window */
static Window walkToToplevel(Display *dpy, Window win) {
    Window root = DefaultRootWindow(dpy);

    /* Walk past 1x1 children */
    for (int i = 0; i < 20; i++) {
        XWindowAttributes wa;
        XGetWindowAttributes(dpy, win, &wa);
        if (wa.width > 1 && wa.height > 1) break;
        Window parent, *children;
        unsigned int nch;
        if (!XQueryTree(dpy, win, &root, &parent, &children, &nch)) break;
        if (children) XFree(children);
        if (parent == root || parent == win) break;
        win = parent;
    }

    /* Walk up to find a window with a title */
    Window cur = win;
    for (int i = 0; i < 20; i++) {
        XTextProperty tp;
        if (XGetWMName(dpy, cur, &tp) && tp.value && strlen((char *)tp.value) > 0) {
            win = cur;
            break;
        }
        Window parent, *children;
        unsigned int nch;
        if (!XQueryTree(dpy, cur, &root, &parent, &children, &nch)) break;
        if (children) XFree(children);
        if (parent == root || parent == cur) break;
        cur = parent;
    }
    return win;
}

/*
 * captureWindow - capture a window to a PNG file
 *
 * titleMatch: if non-NULL, find window by title substring
 * outdir:     output directory, or NULL for current directory
 * returns:    0 on success, -1 on failure
 */
int captureWindow(const char *titleMatch, const char *outdir) {
    Display *dpy = XOpenDisplay(NULL);
    if (!dpy) {
        fprintf(stderr, "screencap: cannot open X display\n");
        return -1;
    }

    Window win = 0;

    if (titleMatch) {
        win = findByTitle(dpy, DefaultRootWindow(dpy), titleMatch);
        if (!win) {
            fprintf(stderr, "screencap: no window matching \"%s\"\n", titleMatch);
            XCloseDisplay(dpy);
            return -1;
        }
    } else {
        const char *wid_str = getenv("WINDOWID");
        if (wid_str)
            win = (Window)strtoul(wid_str, NULL, 0);
        if (!win) {
            int revert;
            XGetInputFocus(dpy, &win, &revert);
        }
        if (!win || win == PointerRoot || win == None) {
            fprintf(stderr, "screencap: no window found\n");
            XCloseDisplay(dpy);
            return -1;
        }
        win = walkToToplevel(dpy, win);
    }

    /* Get window title */
    char title[256] = "untitled";
    XTextProperty prop;
    if (XGetWMName(dpy, win, &prop) && prop.value)
        snprintf(title, sizeof(title), "%s", (char *)prop.value);

    /* Get window geometry and translate to root coordinates */
    XWindowAttributes attrs;
    XGetWindowAttributes(dpy, win, &attrs);
    int w = attrs.width;
    int h = attrs.height;

    int root_x, root_y;
    Window child;
    XTranslateCoordinates(dpy, win, attrs.root, 0, 0, &root_x, &root_y, &child);

    /* Strip CSD shadow: _GTK_FRAME_EXTENTS gives left,right,top,bottom insets */
    Atom gtk_frame = XInternAtom(dpy, "_GTK_FRAME_EXTENTS", False);
    Atom net_frame = XInternAtom(dpy, "_NET_FRAME_EXTENTS", False);
    Atom actual_type;
    int actual_format;
    unsigned long nitems, bytes_after;
    unsigned char *frame_data = NULL;
    long left = 0, right = 0, top = 0, bottom = 0;

    if ((XGetWindowProperty(dpy, win, gtk_frame, 0, 4, False, XA_CARDINAL,
            &actual_type, &actual_format, &nitems, &bytes_after, &frame_data) == Success
            && nitems == 4) ||
        (XGetWindowProperty(dpy, win, net_frame, 0, 4, False, XA_CARDINAL,
            &actual_type, &actual_format, &nitems, &bytes_after, &frame_data) == Success
            && nitems == 4)) {
        long *extents = (long *)frame_data;
        left = extents[0]; right = extents[1];
        top = extents[2]; bottom = extents[3];
    }
    if (frame_data) XFree(frame_data);

    root_x += left;
    root_y += top;
    w -= left + right;
    h -= top + bottom;

    /* Clamp capture region to screen bounds to avoid BadMatch */
    int scr_w = DisplayWidth(dpy, DefaultScreen(dpy));
    int scr_h = DisplayHeight(dpy, DefaultScreen(dpy));
    int cap_x = root_x < 0 ? 0 : root_x;
    int cap_y = root_y < 0 ? 0 : root_y;
    int cap_w = w - (cap_x - root_x);
    int cap_h = h - (cap_y - root_y);
    if (cap_x + cap_w > scr_w) cap_w = scr_w - cap_x;
    if (cap_y + cap_h > scr_h) cap_h = scr_h - cap_y;

    if (cap_w <= 0 || cap_h <= 0) {
        fprintf(stderr, "screencap: window not visible on screen\n");
        XCloseDisplay(dpy);
        return -1;
    }

    /* Capture from root window at the target window's position.
       Avoids BadMatch on composited/obscured windows. */
    XImage *img = XGetImage(dpy, attrs.root, cap_x, cap_y, cap_w, cap_h, AllPlanes, ZPixmap);
    if (!img) {
        fprintf(stderr, "screencap: XGetImage failed (%dx%d at %d,%d)\n", cap_w, cap_h, cap_x, cap_y);
        XCloseDisplay(dpy);
        return -1;
    }
    w = cap_w;
    h = cap_h;

    /* Convert XImage to RGB pixels */
    unsigned char *pixels = malloc(w * h * 3);
    for (int y = 0; y < h; y++) {
        for (int x = 0; x < w; x++) {
            unsigned long pixel = XGetPixel(img, x, y);
            int idx = (y * w + x) * 3;
            pixels[idx + 0] = (pixel >> 16) & 0xFF;
            pixels[idx + 1] = (pixel >>  8) & 0xFF;
            pixels[idx + 2] =  pixel        & 0xFF;
        }
    }
    XDestroyImage(img);
    XCloseDisplay(dpy);

    /* Build filename: YYYY-MM-DD_HHMMSS_title.png */
    time_t now = time(NULL);
    struct tm *t = localtime(&now);
    char safetitle[128];
    sanitizeFilename(safetitle, title, sizeof(safetitle));

    char path[512];
    snprintf(path, sizeof(path), "%s/%04d-%02d-%02d_%02d%02d%02d_%s.png",
             outdir ? outdir : ".",
             t->tm_year + 1900, t->tm_mon + 1, t->tm_mday,
             t->tm_hour, t->tm_min, t->tm_sec,
             safetitle);

    if (writePng(path, pixels, w, h) != 0) {
        fprintf(stderr, "screencap: failed to write %s\n", path);
        free(pixels);
        return -1;
    }

    printf("screencap: saved %s (%dx%d)\n", path, w, h);
    free(pixels);
    return 0;
}

#ifdef SCREENCAP_STANDALONE
int main(int argc, char *argv[]) {
    const char *titleMatch = NULL;
    const char *outdir = NULL;

    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-t") == 0 && i + 1 < argc)
            titleMatch = argv[++i];
        else
            outdir = argv[i];
    }

    return captureWindow(titleMatch, outdir) == 0 ? 0 : 1;
}
#endif
