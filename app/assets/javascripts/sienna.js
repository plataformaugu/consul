(() => {
  "use strict";
  function i(n) {
    var i = t(t({}, e), { states: t(t({}, e.states), n) });
    a(i);
    return i;
  }
  function a(i) {
    e = t(t({}, e), i);
    (function (t, e, n) {
      var i = new Date();
      i.setTime(i.getTime() + 24 * n * 60 * 60 * 1e3);
      var a = "expires=" + i.toUTCString();
      document.cookie = t + "=" + e + ";" + a + ";path=/";
    })(n, JSON.stringify(e));
  }
  function o(t) {
    var n;
    if ((n = e == null ? void 0 : e.states) === null || n === void 0) {
      return;
    } else {
      return n[t];
    }
  }
  function s(t) {
    if (t === void 0) {
      t = true;
    }
    if (t) {
      return e;
    }
    var i = (function (t) {
      var e = t + "=";
      var n = decodeURIComponent(document.cookie).split(";");
      for (var i = 0; i < n.length; i++) {
        for (var a = n[i]; a.charAt(0) == " "; ) {
          a = a.substring(1);
        }
        if (a.indexOf(e) == 0) {
          return a.substring(e.length, a.length);
        }
      }
      return "";
    })(n);
    if (i) {
      e = JSON.parse(i);
    }
    return e;
  }
  function r(t) {
    if (t === void 0) {
      t = 1;
    }
    document
      .querySelectorAll(
        "h1,h2,h3,h4,h5,h6,p,a,dl,dt,li,ol,th,td,span,blockquote,.asw-text"
      )
      .forEach(function (e) {
        var n;
        if (
          !e.classList.contains("material-icons") &&
          !e.classList.contains("fa")
        ) {
          var i = Number(
            (n = e.getAttribute("data-asw-orgFontSize")) !== null &&
              n !== void 0
              ? n
              : 0
          );
          if (!i) {
            i = parseInt(
              window.getComputedStyle(e).getPropertyValue("font-size")
            );
            e.setAttribute("data-asw-orgFontSize", String(i));
          }
          var a = i * t;
          e.style["font-size"] = a + "px";
        }
      });
    var e = document.querySelector(".asw-amount");
    if (e) {
      e.innerText = "".concat((100 * t).toFixed(0), "%");
    }
  }
  function l(t) {
    var e = t.id;
    var n = t.css;
    if (n) {
      var i =
        document.getElementById(e || "") || document.createElement("style");
      i.innerHTML = n;
      if (!i.id) {
        i.id = e;
        document.head.appendChild(i);
      }
    }
  }
  function u(t) {
    var e;
    var n = "";
    if (t) {
      if (
        (n += (function (t) {
          var e = "";
          if (t) {
            var n = function (n) {
              (g.includes(n) ? c : [""]).forEach(function (i) {
                e += "".concat(i).concat(n, ":").concat(t[n], " !important;");
              });
            };
            for (var i in t) {
              n(i);
            }
          }
          return e;
        })(t.styles)).length &&
        t.selector
      ) {
        n = (function (t) {
          var e = t.selector;
          var n = t.childrenSelector;
          var i = n === void 0 ? [""] : n;
          var a = t.css;
          var o = "";
          i.forEach(function (t) {
            o += "".concat(e, " ").concat(t, "{").concat(a, "}");
          });
          return o;
        })({
          selector: t.selector,
          childrenSelector: t.childrenSelector,
          css: n,
        });
      }
      n += (e = t.css) !== null && e !== void 0 ? e : "";
    }
    return n;
  }
  function d(t) {
    var e;
    var n = t.id;
    var i = n === void 0 ? "" : n;
    var a = t.enable;
    var o = a !== void 0 && a;
    var s = "asw-".concat(i);
    if (o) {
      l({ css: u(t), id: s });
    } else if ((e = document.getElementById(s)) !== null && e !== void 0) {
      e.remove();
    }
    document.documentElement.classList.toggle(s, o);
  }
  function w() {
    var t = s().states.contrast;
    var e = "";
    var n = b[t];
    if (n) {
      e = u(S(S({}, n), { selector: "html.aws-filter" }));
    }
    l({ css: e, id: "asw-filter-style" });
    document.documentElement.classList.toggle("aws-filter", Boolean(t));
  }
  function P() {
    var t;
    var e = s().states;
    if ((t = e["highlight-title"]) === void 0) {
      t = false;
    }
    d(F(F({}, x), { enable: t }));
    (function () {
      var t = e["highlight-links"];
      if (t === void 0) {
        t = false;
      }
      d(z(z({}, j), { enable: t }));
    })();
    (function () {
      var t = e["letter-spacing"];
      if (t === void 0) {
        t = false;
      }
      d(M(M({}, D), { enable: t }));
    })();
    (function () {
      var t = e["line-height"];
      if (t === void 0) {
        t = false;
      }
      d(R(R({}, O), { enable: t }));
    })();
    (function () {
      var t = e["font-weight"];
      if (t === void 0) {
        t = false;
      }
      d(T(T({}, B), { enable: t }));
    })();
    (function () {
      var t = e["readable-font"];
      if (t === void 0) {
        t = false;
      }
      d(k(k({}, C), { enable: t }));
    })();
    (function (t) {
      if (t === void 0) {
        t = false;
      }
      var e = document.querySelector(".asw-rg-container");
      if (t) {
        if (!e) {
          (e = document.createElement("div")).setAttribute(
            "class",
            "asw-rg-container"
          );
          e.innerHTML = H;
          var n = e.querySelector(".asw-rg-top");
          var i = e.querySelector(".asw-rg-bottom");
          window.__asw__onScrollReadableGuide = function (t) {
            n.style.height = t.clientY - 20 + "px";
            i.style.height = window.innerHeight - t.clientY - 40 + "px";
          };
          document.addEventListener(
            "mousemove",
            window.__asw__onScrollReadableGuide,
            { passive: false }
          );
          document.body.appendChild(e);
        }
      } else {
        if (e) {
          e.remove();
        }
        if (window.__asw__onScrollReadableGuide) {
          document.removeEventListener(
            "mousemove",
            window.__asw__onScrollReadableGuide
          );
          delete window.__asw__onScrollReadableGuide;
        }
      }
    })(e["readable-guide"]);
    (function () {
      var t = e["stop-animations"];
      if (t === void 0) {
        t = false;
      }
      d(f(f({}, y), { enable: t }));
    })();
    (function () {
      var t = e["big-cursor"];
      if (t === void 0) {
        t = false;
      }
      d(A(A({}, L), { enable: t }));
    })();
  }
  function I() {
    var t = s().states;
    r((t == null ? void 0 : t.fontSize) || 1);
    P();
    w();
  }
  function N(t, e) {
    t.style.display =
      e === void 0
        ? t.style.display === "none"
          ? "block"
          : "none"
        : e == 1
        ? "block"
        : "none";
  }
  function W(t, e) {
    var n = "";
    for (var i = t.length; i--; ) {
      var a = t[i];
      n += '<button class="asw-btn '
        .concat(e || "", '" type="button" data-key="')
        .concat(a.key, '" title="')
        .concat(a.label, '">')
        .concat(a.icon, '<span class="asw-translate">')
        .concat(a.label, "</span></button>");
    }
    return n;
  }
  function q(t, e) {
    var n = t.getAttribute("data-translate");
    if (!n && e) {
      n = e;
      t.setAttribute("data-translate", n);
    }
    return (function () {
      var t = n;
      var e = s().lang;
      return (K[e] || K.en)[t] || t;
    })();
  }
  function U(t) {
    t.querySelectorAll(".asw-card-title, .asw-translate").forEach(function (t) {
      t.innerText = q(t, String(t.innerText || "").trim());
    });
    t.querySelectorAll("[title]").forEach(function (t) {
      t.setAttribute("title", q(t, t.getAttribute("title")));
    });
  }
  function Q(t) {
    var e;
    var n;
    var l;
    var c;
    var g = t.container;
    var u = t.position;
    var d = Y(t, ["container", "position"]);
    var h = document.createElement("div");
    h.innerHTML = G;
    var p = h.querySelector(".asw-menu");
    if (u == null ? void 0 : u.includes("right")) {
      p.style.right = "0px";
      p.style.left = "auto";
    }
    p.querySelector(".content").innerHTML = W(Z);
    p.querySelector(".tools").innerHTML = W(J, "asw-tools");
    p.querySelector(".contrast").innerHTML = W(E, "asw-filter");
    h.querySelectorAll(".asw-menu-close, .asw-overlay").forEach(function (t) {
      t.addEventListener("click", function () {
        N(h, false);
      });
    });
    p.querySelectorAll(".asw-adjust-font div[role='button']").forEach(function (
      t
    ) {
      t.addEventListener("click", function () {
        var e;
        var n = (e = o("fontSize")) !== null && e !== void 0 ? e : 1;
        if (t.classList.contains("asw-minus")) {
          n -= 0.1;
        } else {
          n += 0.1;
        }
        n = Math.max(n, 0.1);
        n = Math.min(n, 2);
        r((n = Number(n.toFixed(2))) || 1);
        i({ fontSize: n });
      });
    });
    p.querySelectorAll(".asw-btn").forEach(function (t) {
      t.addEventListener("click", function () {
        var e;
        var n = t.dataset.key;
        var a = !t.classList.contains("asw-selected");
        if (t.classList.contains("asw-filter")) {
          p.querySelectorAll(".asw-filter").forEach(function (t) {
            t.classList.remove("asw-selected");
          });
          i({ contrast: !!a && n });
          if (a) {
            t.classList.add("asw-selected");
          }
          w();
        } else {
          t.classList.toggle("asw-selected", a);
          i((((e = {})[n] = a), e));
          P();
        }
      });
    });
    if ((e = p.querySelector(".asw-menu-reset")) !== null && e !== void 0) {
      e.addEventListener("click", function () {
        var t;
        a({ states: {} });
        I();
        if (
          (t =
            document === null || document === void 0
              ? void 0
              : document.querySelectorAll(".asw-selected")) !== null &&
          t !== void 0
        ) {
          t.forEach(function (t) {
            var e;
            if (
              (e = t == null ? void 0 : t.classList) === null ||
              e === void 0
            ) {
              return;
            } else {
              return e.remove("asw-selected");
            }
          });
        }
      });
    }
    var m = s();
    var v =
      Number(
        (n = m == null ? void 0 : m.states) === null || n === void 0
          ? void 0
          : n.fontSize
      ) || 1;
    if (v != 1) {
      p.querySelector(".asw-amount").innerHTML = "".concat(100 * v, "%");
    }
    U(p);
    if (m.states) {
      for (var S in m.states) {
        if (m.states[S] && S !== "fontSize") {
          var f = S === "contrast" ? m.states[S] : S;
          if (
            (c =
              (l = p.querySelector('.asw-btn[data-key="'.concat(f, '"]'))) ===
                null || l === void 0
                ? void 0
                : l.classList) !== null &&
            c !== void 0
          ) {
            c.add("asw-selected");
          }
        }
      }
    }
    g.appendChild(h);
    return h;
  }
  function et(t) {
    var e = $({}, tt);
    try {
      var n = s(false);
      e = $($({}, e), n);
      I();
    } catch (t) {}
    a((e = $($({}, e), t)));
    (function (t) {
      var e;
      var n;
      var i;
      var a;
      var o;
      var s;
      var r = t.position;
      var l = r === void 0 ? "bottom-left" : r;
      var c = t.offset;
      var g = c === void 0 ? [20, 20] : c;
      var u = document.createElement("div");
      u.innerHTML = V;
      u.classList.add("asw-container");
      var d;
      var h = u.querySelector(".asw-menu-btn");
      var p = (e = g == null ? void 0 : g[0]) !== null && e !== void 0 ? e : 20;
      var m = (n = g == null ? void 0 : g[1]) !== null && n !== void 0 ? n : 25;
      var v = { left: "".concat(p, "px"), bottom: "".concat(m, "px") };
      if (l === "bottom-right") {
        v = X(X({}, v), { right: "".concat(p, "px"), left: "auto" });
      } else if (l === "top-left") {
        v = X(X({}, v), { top: "".concat(m, "px"), bottom: "auto" });
      } else if (l === "center-left") {
        v = X(X({}, v), {
          bottom: "calc(50% - (55px / 2) - ".concat(
            (i = g == null ? void 0 : g[1]) !== null && i !== void 0 ? i : 0,
            "px)"
          ),
        });
      } else if (l === "top-right") {
        v = {
          top: "".concat(m, "px"),
          bottom: "auto",
          right: "".concat(p, "px"),
          left: "auto",
        };
      } else if (l === "center-right") {
        v = {
          right: "".concat(p, "px"),
          left: "auto",
          bottom: "calc(50% - (55px / 2) - ".concat(
            (a = g == null ? void 0 : g[1]) !== null && a !== void 0 ? a : 0,
            "px)"
          ),
        };
      } else if (l === "bottom-center") {
        v = X(X({}, v), {
          left: "calc(50% - (55px / 2) - ".concat(
            (o = g == null ? void 0 : g[0]) !== null && o !== void 0 ? o : 0,
            "px)"
          ),
        });
      } else if (l === "top-center") {
        v = {
          top: "".concat(m, "px"),
          bottom: "auto",
          left: "calc(50% - (55px / 2) - ".concat(
            (s = g == null ? void 0 : g[0]) !== null && s !== void 0 ? s : 0,
            "px)"
          ),
        };
      }
      Object.assign(h.style, v);
      if (h != null) {
        h.addEventListener("click", function (e) {
          e.preventDefault();
          if (d) {
            N(d);
          } else {
            d = Q(X(X({}, t), { container: u }));
          }
        });
      }
      U(u);
      document.body.appendChild(u);
    })(e);
  }
  function nt(t) {
    var e;
    t = "data-asw-".concat(t);
    if (
      (e =
        document === null || document === void 0
          ? void 0
          : document.querySelector("[".concat(t, "]"))) === null ||
      e === void 0
    ) {
      return;
    } else {
      return e.getAttribute(t);
    }
  }
  var t = function () {
    t =
      Object.assign ||
      function (t) {
        var e;
        var n = 1;
        for (var i = arguments.length; n < i; n++) {
          for (var a in (e = arguments[n])) {
            if (Object.prototype.hasOwnProperty.call(e, a)) {
              t[a] = e[a];
            }
          }
        }
        return t;
      };
    return t.apply(this, arguments);
  };
  var e = {};
  var n = "asw";
  var c = ["-o-", "-ms-", "-moz-", "-webkit-", ""];
  var g = ["filter"];
  var h = function (t, e, n) {
    if (n || arguments.length === 2) {
      var i;
      var a = 0;
      for (var o = e.length; a < o; a++) {
        if (!!i || !(a in e)) {
          if (!i) {
            i = Array.prototype.slice.call(e, 0, a);
          }
          i[a] = e[a];
        }
      }
    }
    return t.concat(i || Array.prototype.slice.call(e));
  };
  var p = ["", "*:not(.material-icons,.asw-menu,.asw-menu *)"];
  var m = [
    "h1",
    "h2",
    "h3",
    "h4",
    "h5",
    "h6",
    ".wsite-headline",
    ".wsite-content-title",
  ];
  var v = h(
    h([], m, true),
    ["img", "p", "i", "svg", "a", "button:not(.asw-btn)", "label", "li", "ol"],
    false
  );
  var b = {
    "dark-contrast": {
      styles: { color: "#FFF", fill: "#FFF", "background-color": "#000" },
      childrenSelector: v,
    },
    "light-contrast": {
      styles: { color: "#000", fill: "#000", "background-color": "#FFF" },
      childrenSelector: v,
    },
    "high-contrast": { styles: { filter: "contrast(125%)" } },
    "high-saturation": { styles: { filter: "saturate(200%)" } },
    "low-saturation": { styles: { filter: "saturate(50%)" } },
    monochrome: { styles: { filter: "grayscale(100%)" } },
  };
  var S = function () {
    S =
      Object.assign ||
      function (t) {
        var e;
        var n = 1;
        for (var i = arguments.length; n < i; n++) {
          for (var a in (e = arguments[n])) {
            if (Object.prototype.hasOwnProperty.call(e, a)) {
              t[a] = e[a];
            }
          }
        }
        return t;
      };
    return S.apply(this, arguments);
  };
  var f = function () {
    f =
      Object.assign ||
      function (t) {
        var e;
        var n = 1;
        for (var i = arguments.length; n < i; n++) {
          for (var a in (e = arguments[n])) {
            if (Object.prototype.hasOwnProperty.call(e, a)) {
              t[a] = e[a];
            }
          }
        }
        return t;
      };
    return f.apply(this, arguments);
  };
  var y = {
    id: "stop-animations",
    selector: "html",
    childrenSelector: ["*"],
    styles: {
      transition: "none",
      "animation-fill-mode": "forwards",
      "animation-iteration-count": "1",
      "animation-duration": ".01s",
    },
  };
  var k = function () {
    k =
      Object.assign ||
      function (t) {
        var e;
        var n = 1;
        for (var i = arguments.length; n < i; n++) {
          for (var a in (e = arguments[n])) {
            if (Object.prototype.hasOwnProperty.call(e, a)) {
              t[a] = e[a];
            }
          }
        }
        return t;
      };
    return k.apply(this, arguments);
  };
  var C = {
    id: "readable-font",
    selector: "html",
    childrenSelector: (function () {
      var t = ["", "*:not(.material-icons,.fa)"];
      var e = v;
      var n = true;
      if (n || arguments.length === 2) {
        var i;
        var a = 0;
        for (var o = e.length; a < o; a++) {
          if (!!i || !(a in e)) {
            if (!i) {
              i = Array.prototype.slice.call(e, 0, a);
            }
            i[a] = e[a];
          }
        }
      }
      return t.concat(i || Array.prototype.slice.call(e));
    })(),
    styles: {
      "font-family": "OpenDyslexic3,Comic Sans MS,Arial,Helvetica,sans-serif",
    },
    css: '@font-face {font-family: OpenDyslexic3;src: url("https://website-widgets.pages.dev/fonts/OpenDyslexic3-Regular.woff") format("woff"), url("https://website-widgets.pages.dev/fonts/OpenDyslexic3-Regular.ttf") format("truetype");}',
  };
  var A = function () {
    A =
      Object.assign ||
      function (t) {
        var e;
        var n = 1;
        for (var i = arguments.length; n < i; n++) {
          for (var a in (e = arguments[n])) {
            if (Object.prototype.hasOwnProperty.call(e, a)) {
              t[a] = e[a];
            }
          }
        }
        return t;
      };
    return A.apply(this, arguments);
  };
  var L = {
    id: "big-cursor",
    selector: "body",
    childrenSelector: ["*"],
    styles: {
      cursor:
        "url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='98px' height='98px' viewBox='0 0 48 48'%3E%3Cpath fill='%23E0E0E0' d='M27.8 39.7c-.1 0-.2 0-.4-.1s-.4-.3-.6-.5l-3.7-8.6-4.5 4.2c-.1.2-.3.3-.6.3-.1 0-.3 0-.4-.1-.3-.1-.6-.5-.6-.9V12c0-.4.2-.8.6-.9.1-.1.3-.1.4-.1.2 0 .5.1.7.3l16 15c.3.3.4.7.3 1.1-.1.4-.5.6-.9.7l-6.3.6 3.9 8.5c.1.2.1.5 0 .8-.1.2-.3.5-.5.6l-2.9 1.3c-.2-.2-.4-.2-.5-.2z'/%3E%3Cpath fill='%23212121' d='m18 12 16 15-7.7.7 4.5 9.8-2.9 1.3-4.3-9.9L18 34V12m0-2c-.3 0-.5.1-.8.2-.7.3-1.2 1-1.2 1.8v22c0 .8.5 1.5 1.2 1.8.3.2.6.2.8.2.5 0 1-.2 1.4-.5l3.4-3.2 3.1 7.3c.2.5.6.9 1.1 1.1.2.1.5.1.7.1.3 0 .5-.1.8-.2l2.9-1.3c.5-.2.9-.6 1.1-1.1.2-.5.2-1.1 0-1.5l-3.3-7.2 4.9-.4c.8-.1 1.5-.6 1.7-1.3.3-.7.1-1.6-.5-2.1l-16-15c-.3-.5-.8-.7-1.3-.7z'/%3E%3C/svg%3E\") 40 15, auto",
    },
  };
  var F = function () {
    F =
      Object.assign ||
      function (t) {
        var e;
        var n = 1;
        for (var i = arguments.length; n < i; n++) {
          for (var a in (e = arguments[n])) {
            if (Object.prototype.hasOwnProperty.call(e, a)) {
              t[a] = e[a];
            }
          }
        }
        return t;
      };
    return F.apply(this, arguments);
  };
  var x = {
    id: "highlight-title",
    selector: "html",
    childrenSelector: m,
    styles: { outline: "2px solid #0048ff", "outline-offset": "2px" },
  };
  const H =
    '<style>.asw-rg{position:fixed;top:0;left:0;right:0;width:100%;height:0;pointer-events:none;background-color:rgba(0,0,0,.8);z-index:1000000}</style> <div class="asw-rg asw-rg-top"></div> <div class="asw-rg asw-rg-bottom" style="top:auto;bottom:0"></div>';
  var z = function () {
    z =
      Object.assign ||
      function (t) {
        var e;
        var n = 1;
        for (var i = arguments.length; n < i; n++) {
          for (var a in (e = arguments[n])) {
            if (Object.prototype.hasOwnProperty.call(e, a)) {
              t[a] = e[a];
            }
          }
        }
        return t;
      };
    return z.apply(this, arguments);
  };
  var j = {
    id: "highlight-links",
    selector: "html",
    childrenSelector: ["a[href]"],
    styles: { outline: "2px solid #0048ff", "outline-offset": "2px" },
  };
  var M = function () {
    M =
      Object.assign ||
      function (t) {
        var e;
        var n = 1;
        for (var i = arguments.length; n < i; n++) {
          for (var a in (e = arguments[n])) {
            if (Object.prototype.hasOwnProperty.call(e, a)) {
              t[a] = e[a];
            }
          }
        }
        return t;
      };
    return M.apply(this, arguments);
  };
  var D = {
    id: "letter-spacing",
    selector: "html",
    childrenSelector: p,
    styles: { "letter-spacing": "2px" },
  };
  var R = function () {
    R =
      Object.assign ||
      function (t) {
        var e;
        var n = 1;
        for (var i = arguments.length; n < i; n++) {
          for (var a in (e = arguments[n])) {
            if (Object.prototype.hasOwnProperty.call(e, a)) {
              t[a] = e[a];
            }
          }
        }
        return t;
      };
    return R.apply(this, arguments);
  };
  var O = {
    id: "line-height",
    selector: "html",
    childrenSelector: p,
    styles: { "line-height": "3" },
  };
  var T = function () {
    T =
      Object.assign ||
      function (t) {
        var e;
        var n = 1;
        for (var i = arguments.length; n < i; n++) {
          for (var a in (e = arguments[n])) {
            if (Object.prototype.hasOwnProperty.call(e, a)) {
              t[a] = e[a];
            }
          }
        }
        return t;
      };
    return T.apply(this, arguments);
  };
  var B = {
    id: "font-weight",
    selector: "html",
    childrenSelector: p,
    styles: { "font-weight": "700" },
  };
  const V =
    '<style>.asw-menu,.asw-widget{-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;font-weight:400;-webkit-font-smoothing:antialiased}.asw-menu *,.asw-widget *{box-sizing:border-box!important}.asw-menu-btn{position:fixed;z-index:500000;left:30px;bottom:30px;box-shadow:0 5px 15px 0 rgb(37 44 97 / 15%),0 2px 4px 0 rgb(93 100 148 / 20%);transition:transform .2s ease;border-radius:50%;align-items:center;justify-content:center;width:58px;height:58px;display:flex;cursor:pointer;border:3px solid #fff!important;outline:5px solid #0048ff!important;text-decoration:none!important;background:#326cff!important;background:linear-gradient(96deg,#326cff 0,#0048ff 100%)!important}.asw-menu-btn svg{width:36px;height:36px;min-height:36px;min-width:36px;max-width:36px;max-height:36px;background:0 0!important}.asw-menu-btn:hover{transform:scale(1.05)}@media only screen and (max-width:768px){.asw-menu-btn{width:42px;height:42px}.asw-menu-btn svg{width:26px;height:26px;min-height:26px;min-width:26px;max-width:26px;max-height:26px}}</style> <div class="asw-widget"> <a href="#" target="_blank" class="asw-menu-btn" title="Open Accessibility Menu" role="button" aria-expanded="false"> <svg xmlns="http://www.w3.org/2000/svg" style="fill:white" viewBox="0 0 24 24" width="30px" height="30px"><path d="M0 0h24v24H0V0z" fill="none"/><path d="M20.5 6c-2.61.7-5.67 1-8.5 1s-5.89-.3-8.5-1L3 8c1.86.5 4 .83 6 1v13h2v-6h2v6h2V9c2-.17 4.14-.5 6-1l-.5-2zM12 6c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2z"/></svg> </a> </div>';
  const G =
    '<style>.asw-menu{position:fixed;left:0;top:0;box-shadow:0 0 20px #00000080;opacity:1;transition:.3s;z-index:500000;overflow:hidden;background:#eff1f5;width:500px;line-height:1;font-size:16px;height:100%;letter-spacing:.015em}.asw-menu *{color:#000!important;font-family:inherit;padding:0;margin:0;line-height:1!important;letter-spacing:normal!important}.asw-menu-header{display:flex;align-items:center;justify-content:space-between;padding-left:18px;padding-right:18px;height:55px;font-weight:700!important;background-color:#0848ca!important}.asw-menu-title{font-size:16px!important;color:#fff!important}.asw-menu-header svg{fill:#0848ca!important;width:24px!important;height:24px!important;min-width:24px!important;min-height:24px!important;max-width:24px!important;max-height:24px!important}.asw-menu-header>div{display:flex}.asw-menu-header div[role=button]{padding:5px;background:#fff!important;cursor:pointer;border-radius:50%;transition:opacity .3s ease}.asw-menu-header div[role=button]:hover{opacity:.8}.asw-card{margin:0 15px 20px}.asw-card-title{font-size:14px!important;padding:15px 0;font-weight:600!important;opacity:.8}.asw-menu .asw-select{width:100%!important;padding:0 15px!important;font-size:16px!important;font-family:inherit!important;font-weight:600!important;border-radius:45px!important;background:#fff!important;border:none!important;min-height:45px!important;max-height:45px!important;height:45px!important;color:inherit!important}.asw-items{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:1rem}.asw-btn{aspect-ratio:6/5;border-radius:12px;padding:0 15px;display:flex;align-items:center;justify-content:center;flex-direction:column;text-align:center;color:#333;font-size:16px!important;background:#fff!important;border:2px solid transparent!important;transition:border-color .2s ease;cursor:pointer;word-break:break-word;gap:10px;position:relative;width:auto!important;height:auto!important}.asw-adjust-font .asw-label div,.asw-btn .asw-translate{font-size:14px!important;font-weight:600!important}.asw-minus,.asw-plus{background-color:#eff1f5!important;border:2px solid transparent;transition:border .2s ease}.asw-minus:hover,.asw-plus:hover{border-color:#0848ca!important}.asw-amount{font-size:18px!important;font-weight:600!important}.asw-adjust-font svg{width:24px!important;height:24px!important;min-width:24px!important;min-height:24px!important;max-width:24px!important;max-height:24px!important}.asw-btn svg{width:34px!important;height:34px!important;min-width:34px!important;min-height:34px!important;max-width:34px!important;max-height:34px!important}.asw-btn.asw-selected,.asw-btn:hover{border-color:#0848ca!important}.asw-btn.asw-selected span,.asw-btn.asw-selected svg{fill:#0848ca!important;color:#0848ca!important}.asw-btn.asw-selected:after{content:"\xE2\u0153\u201C";position:absolute;top:10px;right:10px;background-color:#0848ca!important;color:#fff;padding:6px;font-size:10px;width:18px;height:18px;border-radius:100%;line-height:6px}.asw-footer{position:absolute;bottom:0;left:0;right:0;background:#fff;padding:20px;text-align:center;border-top:2px solid #eff1f5}.asw-footer a{font-size:16px!important;text-decoration:none!important;color:#000!important;background:0 0!important;font-weight:600!important}.asw-footer a:hover,.asw-footer a:hover span{color:#0848ca!important}.asw-menu-content{overflow:scroll;max-height:calc(100% - 80px);padding:30px 0 15px}.asw-adjust-font{background:#fff;padding:20px;margin-bottom:20px}.asw-adjust-font .asw-label{display:flex;justify-content:flex-start}.asw-adjust-font>div{display:flex;justify-content:space-between;margin-top:20px;align-items:center;font-size:15px}.asw-adjust-font .asw-label div{font-size:15px!important}.asw-adjust-font div[role=button]{background:#eff1f5!important;border-radius:50%;width:36px;height:36px;display:flex;align-items:center;justify-content:center;cursor:pointer}.asw-overlay{position:fixed;top:0;left:0;width:100%;height:100%;z-index:10000}@media only screen and (max-width:560px){.asw-menu{width:100%}}@media only screen and (max-width:420px){.asw-items{grid-template-columns:repeat(2,minmax(0,1fr));gap:.5rem}}</style> <div class="asw-menu"> <div class="asw-menu-header"> <div class="asw-menu-title asw-translate"> Accessibility Menu </div> <div style="gap:15px"> <div role="button" class="asw-menu-reset" title="Reset settings"> <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"> <path d="M12 4c2.1 0 4.1.8 5.6 2.3 3.1 3.1 3.1 8.2 0 11.3a7.78 7.78 0 0 1-6.7 2.3l.5-2c1.7.2 3.5-.4 4.8-1.7a6.1 6.1 0 0 0 0-8.5A6.07 6.07 0 0 0 12 6v4.6l-5-5 5-5V4M6.3 17.6C3.7 15 3.3 11 5.1 7.9l1.5 1.5c-1.1 2.2-.7 5 1.2 6.8.5.5 1.1.9 1.8 1.2l-.6 2a8 8 0 0 1-2.7-1.8Z"/> </svg> </div> <div role="button" class="asw-menu-close" title="Close"> <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"> <path d="M19 6.41 17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12 19 6.41Z"/> </svg> </div> </div> </div> <div class="asw-menu-content"><div class="asw-card"> <div class="asw-card-title"> Content Adjustments </div> <div class="asw-adjust-font"> <div class="asw-label" style="margin:0"> <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" style="margin-right:15px"> <path d="M2 4v3h5v12h3V7h5V4H2m19 5h-9v3h3v7h3v-7h3V9Z"/> </svg> <div class="asw-translate"> Adjust Font Size </div> </div> <div> <div class="asw-minus" data-key="font-size" role="button" aria-pressed="false" title="Decrease Font Size" tabindex="0"> <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"> <path d="M19 13H5v-2h14v2Z"/> </svg> </div> <div class="asw-amount"> 100% </div> <div class="asw-plus" data-key="font-size" role="button" aria-pressed="false" title="Increase Font Size" tabindex="0"> <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"> <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2Z"/> </svg> </div> </div> </div> <div class="asw-items content"> </div> </div> <div class="asw-card"> <div class="asw-card-title"> Color Adjustments </div> <div class="asw-items contrast"> </div> </div> <div class="asw-card"> <div class="asw-card-title"> Tools </div> <div class="asw-items tools"> </div> </div> </div>  </div> <div class="asw-overlay"> </div>';
  const E = [
    {
      label: "Monochrome",
      key: "monochrome",
      icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\r<path d="m19 19-7-8v8H5l7-8V5h7m0-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V5a2 2 0 0 0-2-2Z"/>\r\n</svg>',
    },
    {
      label: "Low Saturation",
      key: "low-saturation",
      icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\r<path d="M11 9h2v2h-2V9m-2 2h2v2H9v-2m4 0h2v2h-2v-2m2-2h2v2h-2V9M7 9h2v2H7V9m12-6H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V5a2 2 0 0 0-2-2M9 18H7v-2h2v2m4 0h-2v-2h2v2m4 0h-2v-2h2v2m2-7h-2v2h2v2h-2v-2h-2v2h-2v-2h-2v2H9v-2H7v2H5v-2h2v-2H5V5h14v6Z"/>\r\n</svg>',
    },
    {
      label: "High Saturation",
      key: "high-saturation",
      icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\r<path d="M12 16a4 4 0 0 1-4-4 4 4 0 0 1 4-4 4 4 0 0 1 4 4 4 4 0 0 1-4 4m6.7-3.6a6.06 6.06 0 0 0-.86-.4 5.98 5.98 0 0 0 3.86-5.59 6 6 0 0 0-6.78.54A5.99 5.99 0 0 0 12 .81a6 6 0 0 0-2.92 6.14A6 6 0 0 0 2.3 6.4 5.95 5.95 0 0 0 6.16 12a6 6 0 0 0-3.86 5.58 6 6 0 0 0 6.78-.54A6 6 0 0 0 12 23.19a6 6 0 0 0 2.92-6.14 6 6 0 0 0 6.78.54 5.98 5.98 0 0 0-3-5.19Z"/>\r\n</svg>',
    },
    {
      label: "High Contrast",
      key: "high-contrast",
      icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\r<path d="M12 2a10 10 0 1 0 0 20 10 10 0 0 0 0-20zm-1 17.93a8 8 0 0 1 0-15.86v15.86zm2-15.86a8 8 0 0 1 2.87.93H13v-.93zM13 7h5.24c.25.31.48.65.68 1H13V7zm0 3h6.74c.08.33.15.66.19 1H13v-1zm0 9.93V19h2.87a8 8 0 0 1-2.87.93zM18.24 17H13v-1h5.92c-.2.35-.43.69-.68 1zm1.5-3H13v-1h6.93a8.4 8.4 0 0 1-.19 1z"/>\r\n</svg>',
    },
    {
      label: "Light Contrast",
      key: "light-contrast",
      icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\r<path d="M12 18a6 6 0 0 1-6-6 6 6 0 0 1 6-6 6 6 0 0 1 6 6 6 6 0 0 1-6 6m8-2.69L23.31 12 20 8.69V4h-4.69L12 .69 8.69 4H4v4.69L.69 12 4 15.31V20h4.69L12 23.31 15.31 20H20v-4.69Z"/>\r\n</svg>',
    },
    {
      label: "Dark Contrast",
      key: "dark-contrast",
      icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\r<path d="M18 12c0-4.5-1.92-8.74-6-10a10 10 0 0 0 0 20c4.08-1.26 6-5.5 6-10Z"/>\r\n</svg>',
    },
  ];
  const Z = [
    {
      label: "Font Weight",
      key: "font-weight",
      icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\r<path d="M13.5 15.5H10v-3h3.5A1.5 1.5 0 0 1 15 14a1.5 1.5 0 0 1-1.5 1.5m-3.5-9h3A1.5 1.5 0 0 1 14.5 8 1.5 1.5 0 0 1 13 9.5h-3m5.6 1.29c.97-.68 1.65-1.79 1.65-2.79 0-2.26-1.75-4-4-4H7v14h7.04c2.1 0 3.71-1.7 3.71-3.79 0-1.52-.86-2.82-2.15-3.42Z"/>\r\n</svg>',
    },
    {
      label: "Line Height",
      key: "line-height",
      icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\r<path d="M21 22H3v-2h18v2m0-18H3V2h18v2m-11 9.7h4l-2-5.4-2 5.4M11.2 6h1.7l4.7 12h-2l-.9-2.6H9.4L8.5 18h-2l4.7-12Z"/>\r\n</svg>',
    },
    {
      label: "Letter Spacing",
      key: "letter-spacing",
      icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\r<path d="M22 3v18h-2V3h2M4 3v18H2V3h2m6 10.7h4l-2-5.4-2 5.4M11.2 6h1.7l4.7 12h-2l-.9-2.6H9.4L8.5 18h-2l4.7-12Z"/>\r\n</svg>',
    },
    {
      label: "Dyslexia Font",
      key: "readable-font",
      icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\r<path d="m21.59 11.59-8.09 8.09L9.83 16l-1.41 1.41 5.08 5.09L23 13M6.43 11 8.5 5.5l2.07 5.5m1.88 5h2.09L9.43 3H7.57L2.46 16h2.09l1.12-3h5.64l1.14 3Z"/>\r\n</svg>',
    },
    {
      label: "Highlight Links",
      key: "highlight-links",
      icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\r<path d="M19 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V5a2 2 0 0 0-2-2m0 16H5V5h14v14m-5.06-8.94a3.37 3.37 0 0 1 0 4.75L11.73 17A3.29 3.29 0 0 1 7 17a3.31 3.31 0 0 1 0-4.74l1.35-1.36-.01.6c-.01.5.07 1 .23 1.44l.05.15-.4.41a1.6 1.6 0 0 0 0 2.28c.61.62 1.67.62 2.28 0l2.2-2.19c.3-.31.48-.72.48-1.15 0-.44-.18-.83-.48-1.14a.87.87 0 0 1 0-1.24.91.91 0 0 1 1.24 0m4.06-.7c0 .9-.35 1.74-1 2.38l-1.34 1.36v-.6c.01-.5-.07-1-.23-1.44l-.05-.14.4-.42a1.6 1.6 0 0 0 0-2.28 1.64 1.64 0 0 0-2.28 0l-2.2 2.2c-.3.3-.48.71-.48 1.14 0 .44.18.83.48 1.14.17.16.26.38.26.62s-.09.46-.26.62a.86.86 0 0 1-.62.25.88.88 0 0 1-.62-.25 3.36 3.36 0 0 1 0-4.75L12.27 7A3.31 3.31 0 0 1 17 7c.65.62 1 1.46 1 2.36Z"/>\r\n</svg>',
    },
    {
      label: "Highlight Title",
      key: "highlight-title",
      icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\r<path d="M5 4v3h5.5v12h3V7H19V4H5Z"/>\r\n</svg>',
    },
  ];
  const J = [
    {
      label: "Big Cursor",
      key: "big-cursor",
      icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\r<path d="M11 1.07C7.05 1.56 4 4.92 4 9h7m-7 6a8 8 0 0 0 8 8 8 8 0 0 0 8-8v-4H4m9-9.93V9h7a8 8 0 0 0-7-7.93Z"/>\r\n</svg>',
    },
    {
      label: "Stop Animations",
      key: "stop-animations",
      icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\r<path d="M22 12c0-5.54-4.46-10-10-10-1.17 0-2.3.19-3.38.56l.7 1.94A7.15 7.15 0 0 1 12 3.97 8.06 8.06 0 0 1 20.03 12 8.06 8.06 0 0 1 12 20.03 8.06 8.06 0 0 1 3.97 12c0-.94.19-1.88.53-2.72l-1.94-.66A10.37 10.37 0 0 0 2 12c0 5.54 4.46 10 10 10s10-4.46 10-10M5.47 3.97c.85 0 1.53.71 1.53 1.5C7 6.32 6.32 7 5.47 7c-.79 0-1.5-.68-1.5-1.53 0-.79.71-1.5 1.5-1.5M18 12c0-3.33-2.67-6-6-6s-6 2.67-6 6 2.67 6 6 6 6-2.67 6-6m-7-3v6H9V9m6 0v6h-2V9"/>\r\n</svg>',
    },
    {
      label: "Reading Guide",
      key: "readable-guide",
      icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\r<path d="M12 8a3 3 0 0 0 3-3 3 3 0 0 0-3-3 3 3 0 0 0-3 3 3 3 0 0 0 3 3m0 3.54A13.15 13.15 0 0 0 3 8v11c3.5 0 6.64 1.35 9 3.54A13.15 13.15 0 0 1 21 19V8c-3.5 0-6.64 1.35-9 3.54Z"/>\r\n</svg>',
    },
  ];
  var K = {
    ar: JSON.parse(
      '{"Accessibility Menu":"\xD9\u201A\xD8\xA7\xD8\xA6\xD9\u2026\xD8\xA9 \xD8\xA5\xD9\u2026\xD9\u0192\xD8\xA7\xD9\u2020\xD9\u0160\xD8\xA9 \xD8\xA7\xD9\u201E\xD9\u02C6\xD8\xB5\xD9\u02C6\xD9\u201E","Reset settings":"\xD8\xA5\xD8\xB9\xD8\xA7\xD8\xAF\xD8\xA9 \xD8\xAA\xD8\xB9\xD9\u0160\xD9\u0160\xD9\u2020 \xD8\xA7\xD9\u201E\xD8\xA5\xD8\xB9\xD8\xAF\xD8\xA7\xD8\xAF\xD8\xA7\xD8\xAA","Close":"\xD8\xA5\xD8\xBA\xD9\u201E\xD8\xA7\xD9\u201A","Content Adjustments":"\xD8\xAA\xD8\xB9\xD8\xAF\xD9\u0160\xD9\u201E\xD8\xA7\xD8\xAA \xD8\xA7\xD9\u201E\xD9\u2026\xD8\xAD\xD8\xAA\xD9\u02C6\xD9\u2030","Adjust Font Size":"\xD8\xAA\xD8\xB9\xD8\xAF\xD9\u0160\xD9\u201E \xD8\xAD\xD8\xAC\xD9\u2026 \xD8\xA7\xD9\u201E\xD8\xAE\xD8\xB7","Highlight Title":"\xD8\xAA\xD8\xB3\xD9\u201E\xD9\u0160\xD8\xB7 \xD8\xA7\xD9\u201E\xD8\xB6\xD9\u02C6\xD8\xA1 \xD8\xB9\xD9\u201E\xD9\u2030 \xD8\xA7\xD9\u201E\xD8\xB9\xD9\u2020\xD9\u02C6\xD8\xA7\xD9\u2020","Highlight Links":"\xD8\xAA\xD8\xB3\xD9\u201E\xD9\u0160\xD8\xB7 \xD8\xA7\xD9\u201E\xD8\xB6\xD9\u02C6\xD8\xA1 \xD8\xB9\xD9\u201E\xD9\u2030 \xD8\xA7\xD9\u201E\xD8\xB1\xD9\u02C6\xD8\xA7\xD8\xA8\xD8\xB7","Readable Font":"\xD8\xAE\xD8\xB7 \xD8\xB3\xD9\u2021\xD9\u201E \xD8\xA7\xD9\u201E\xD9\u201A\xD8\xB1\xD8\xA7\xD8\xA1\xD8\xA9","Color Adjustments":"\xD8\xAA\xD8\xB9\xD8\xAF\xD9\u0160\xD9\u201E\xD8\xA7\xD8\xAA \xD8\xA7\xD9\u201E\xD8\xA3\xD9\u201E\xD9\u02C6\xD8\xA7\xD9\u2020","Dark Contrast":"\xD8\xAA\xD8\xA8\xD8\xA7\xD9\u0160\xD9\u2020 \xD8\xAF\xD8\xA7\xD9\u0192\xD9\u2020","Light Contrast":"\xD8\xAA\xD8\xA8\xD8\xA7\xD9\u0160\xD9\u2020 \xD9\x81\xD8\xA7\xD8\xAA\xD8\xAD","High Contrast":"\xD8\xAA\xD8\xA8\xD8\xA7\xD9\u0160\xD9\u2020 \xD8\xB9\xD8\xA7\xD9\u201E\xD9\u0160","High Saturation":"\xD8\xAA\xD8\xB4\xD8\xA8\xD8\xB9 \xD8\xB9\xD8\xA7\xD9\u201E\xD9\u0160","Low Saturation":"\xD8\xAA\xD8\xB4\xD8\xA8\xD8\xB9 \xD9\u2026\xD9\u2020\xD8\xAE\xD9\x81\xD8\xB6","Monochrome":"\xD8\xA3\xD8\xAD\xD8\xA7\xD8\xAF\xD9\u0160 \xD8\xA7\xD9\u201E\xD9\u201E\xD9\u02C6\xD9\u2020","Tools":"\xD8\xA3\xD8\xAF\xD9\u02C6\xD8\xA7\xD8\xAA","Reading Guide":"\xD8\xAF\xD9\u201E\xD9\u0160\xD9\u201E \xD8\xA7\xD9\u201E\xD9\u201A\xD8\xB1\xD8\xA7\xD8\xA1\xD8\xA9","Stop Animations":"\xD8\xA5\xD9\u0160\xD9\u201A\xD8\xA7\xD9\x81 \xD8\xA7\xD9\u201E\xD8\xB1\xD8\xB3\xD9\u02C6\xD9\u2026 \xD8\xA7\xD9\u201E\xD9\u2026\xD8\xAA\xD8\xAD\xD8\xB1\xD9\u0192\xD8\xA9","Big Cursor":"\xD9\u2026\xD8\xA4\xD8\xB4\xD8\xB1 \xD9\u0192\xD8\xA8\xD9\u0160\xD8\xB1","Increase Font Size":"\xD8\xB2\xD9\u0160\xD8\xA7\xD8\xAF\xD8\xA9 \xD8\xAD\xD8\xAC\xD9\u2026 \xD8\xA7\xD9\u201E\xD8\xAE\xD8\xB7","Decrease Font Size":"\xD8\xAA\xD9\u201A\xD9\u201E\xD9\u0160\xD9\u201E \xD8\xAD\xD8\xAC\xD9\u2026 \xD8\xA7\xD9\u201E\xD8\xAE\xD8\xB7","Letter Spacing":"\xD8\xAA\xD8\xA8\xD8\xA7\xD8\xB9\xD8\xAF \xD8\xA7\xD9\u201E\xD8\xAD\xD8\xB1\xD9\u02C6\xD9\x81","Line Height":"\xD8\xA7\xD8\xB1\xD8\xAA\xD9\x81\xD8\xA7\xD8\xB9 \xD8\xA7\xD9\u201E\xD8\xB3\xD8\xB7\xD8\xB1","Font Weight":"\xD8\xB3\xD9\u2026\xD8\xA7\xD9\u0192\xD8\xA9 \xD8\xA7\xD9\u201E\xD8\xAE\xD8\xB7","Dyslexia Font":"\xD8\xAE\xD8\xB7 \xD8\xA7\xD9\u201E\xD9\u201A\xD8\xB1\xD8\xA7\xD8\xA1\xD8\xA9 \xD9\u201E\xD9\u2026\xD9\u2020 \xD9\u0160\xD8\xB9\xD8\xA7\xD9\u2020\xD9\u02C6\xD9\u2020 \xD9\u2026\xD9\u2020 \xD8\xB9\xD8\xB3\xD8\xB1 \xD8\xA7\xD9\u201E\xD9\u201A\xD8\xB1\xD8\xA7\xD8\xA1\xD8\xA9","Language":"\xD8\xA7\xD9\u201E\xD9\u201E\xD8\xBA\xD8\xA9","Open Accessibility Menu":"\xD8\xA7\xD9\x81\xD8\xAA\xD8\xAD \xD9\u201A\xD8\xA7\xD8\xA6\xD9\u2026\xD8\xA9 \xD8\xA7\xD9\u201E\xD9\u02C6\xD8\xB5\xD9\u02C6\xD9\u201E"}'
    ),
    bg: JSON.parse(
      '{"Accessibility Menu":"\xD0\u0153\xD0\xB5\xD0\xBD\xD1\u017D \xD0\xB7\xD0\xB0 \xD0\xB4\xD0\xBE\xD1\x81\xD1\u201A\xD1\u0160\xD0\xBF\xD0\xBD\xD0\xBE\xD1\x81\xD1\u201A","Reset settings":"\xD0\x9D\xD1\u0192\xD0\xBB\xD0\xB8\xD1\u20AC\xD0\xB0\xD0\xBD\xD0\xB5 \xD0\xBD\xD0\xB0 \xD0\xBD\xD0\xB0\xD1\x81\xD1\u201A\xD1\u20AC\xD0\xBE\xD0\xB9\xD0\xBA\xD0\xB8\xD1\u201A\xD0\xB5","Close":"\xD0\u2014\xD0\xB0\xD1\u201A\xD0\xB2\xD0\xBE\xD1\u20AC\xD0\xB8","Content Adjustments":"\xD0\x9D\xD0\xB0\xD1\x81\xD1\u201A\xD1\u20AC\xD0\xBE\xD0\xB9\xD0\xBA\xD0\xB8 \xD0\xBD\xD0\xB0 \xD1\x81\xD1\u0160\xD0\xB4\xD1\u0160\xD1\u20AC\xD0\xB6\xD0\xB0\xD0\xBD\xD0\xB8\xD0\xB5\xD1\u201A\xD0\xBE","Adjust Font Size":"\xD0\x9D\xD0\xB0\xD1\x81\xD1\u201A\xD1\u20AC\xD0\xBE\xD0\xB9\xD0\xBA\xD0\xB0 \xD0\xBD\xD0\xB0 \xD1\u20AC\xD0\xB0\xD0\xB7\xD0\xBC\xD0\xB5\xD1\u20AC\xD0\xB0 \xD0\xBD\xD0\xB0 \xD1\u02C6\xD1\u20AC\xD0\xB8\xD1\u201E\xD1\u201A\xD0\xB0","Highlight Title":"\xD0\u017E\xD1\u201A\xD0\xBA\xD1\u20AC\xD0\xBE\xD1\x8F\xD0\xB2\xD0\xB0\xD0\xBD\xD0\xB5 \xD0\xBD\xD0\xB0 \xD0\xB7\xD0\xB0\xD0\xB3\xD0\xBB\xD0\xB0\xD0\xB2\xD0\xB8\xD0\xB5\xD1\u201A\xD0\xBE","Highlight Links":"\xD0\u017E\xD1\u201A\xD0\xBA\xD1\u20AC\xD0\xBE\xD1\x8F\xD0\xB2\xD0\xB0\xD0\xBD\xD0\xB5 \xD0\xBD\xD0\xB0 \xD0\xB2\xD1\u20AC\xD1\u0160\xD0\xB7\xD0\xBA\xD0\xB8\xD1\u201A\xD0\xB5","Readable Font":"\xD0\xA7\xD0\xB5\xD1\u201A\xD0\xB8\xD0\xBC \xD1\u02C6\xD1\u20AC\xD0\xB8\xD1\u201E\xD1\u201A","Color Adjustments":"\xD0\x9D\xD0\xB0\xD1\x81\xD1\u201A\xD1\u20AC\xD0\xBE\xD0\xB9\xD0\xBA\xD0\xB8 \xD0\xBD\xD0\xB0 \xD1\u2020\xD0\xB2\xD0\xB5\xD1\u201A\xD0\xBE\xD0\xB2\xD0\xB5\xD1\u201A\xD0\xB5","Dark Contrast":"\xD0\xA2\xD1\u0160\xD0\xBC\xD0\xB5\xD0\xBD \xD0\xBA\xD0\xBE\xD0\xBD\xD1\u201A\xD1\u20AC\xD0\xB0\xD1\x81\xD1\u201A","Light Contrast":"\xD0\xA1\xD0\xB2\xD0\xB5\xD1\u201A\xD1\u0160\xD0\xBB \xD0\xBA\xD0\xBE\xD0\xBD\xD1\u201A\xD1\u20AC\xD0\xB0\xD1\x81\xD1\u201A","High Contrast":"\xD0\u2019\xD0\xB8\xD1\x81\xD0\xBE\xD0\xBA \xD0\xBA\xD0\xBE\xD0\xBD\xD1\u201A\xD1\u20AC\xD0\xB0\xD1\x81\xD1\u201A","High Saturation":"\xD0\u2019\xD0\xB8\xD1\x81\xD0\xBE\xD0\xBA\xD0\xB0 \xD0\xBD\xD0\xB0\xD1\x81\xD0\xB8\xD1\u201A\xD0\xB5\xD0\xBD\xD0\xBE\xD1\x81\xD1\u201A","Low Saturation":"\xD0\x9D\xD0\xB8\xD1\x81\xD0\xBA\xD0\xB0 \xD0\xBD\xD0\xB0\xD1\x81\xD0\xB8\xD1\u201A\xD0\xB5\xD0\xBD\xD0\xBE\xD1\x81\xD1\u201A","Monochrome":"\xD0\u0153\xD0\xBE\xD0\xBD\xD0\xBE\xD1\u2026\xD1\u20AC\xD0\xBE\xD0\xBC\xD0\xB5\xD0\xBD","Tools":"\xD0\u02DC\xD0\xBD\xD1\x81\xD1\u201A\xD1\u20AC\xD1\u0192\xD0\xBC\xD0\xB5\xD0\xBD\xD1\u201A\xD0\xB8","Reading Guide":"\xD0 \xD1\u0160\xD0\xBA\xD0\xBE\xD0\xB2\xD0\xBE\xD0\xB4\xD1\x81\xD1\u201A\xD0\xB2\xD0\xBE \xD0\xB7\xD0\xB0 \xD1\u2021\xD0\xB5\xD1\u201A\xD0\xB5\xD0\xBD\xD0\xB5","Stop Animations":"\xD0\xA1\xD0\xBF\xD1\u20AC\xD0\xB8 \xD0\xB0\xD0\xBD\xD0\xB8\xD0\xBC\xD0\xB0\xD1\u2020\xD0\xB8\xD0\xB8\xD1\u201A\xD0\xB5","Big Cursor":"\xD0\u201C\xD0\xBE\xD0\xBB\xD1\x8F\xD0\xBC \xD0\xBA\xD1\u0192\xD1\u20AC\xD1\x81\xD0\xBE\xD1\u20AC","Increase Font Size":"\xD0\xA3\xD0\xB2\xD0\xB5\xD0\xBB\xD0\xB8\xD1\u2021\xD0\xB8 \xD1\u20AC\xD0\xB0\xD0\xB7\xD0\xBC\xD0\xB5\xD1\u20AC\xD0\xB0 \xD0\xBD\xD0\xB0 \xD1\u02C6\xD1\u20AC\xD0\xB8\xD1\u201E\xD1\u201A\xD0\xB0","Decrease Font Size":"\xD0\x9D\xD0\xB0\xD0\xBC\xD0\xB0\xD0\xBB\xD0\xB8 \xD1\u20AC\xD0\xB0\xD0\xB7\xD0\xBC\xD0\xB5\xD1\u20AC\xD0\xB0 \xD0\xBD\xD0\xB0 \xD1\u02C6\xD1\u20AC\xD0\xB8\xD1\u201E\xD1\u201A\xD0\xB0","Letter Spacing":"\xD0 \xD0\xB0\xD0\xB7\xD1\x81\xD1\u201A\xD0\xBE\xD1\x8F\xD0\xBD\xD0\xB8\xD0\xB5 \xD0\xBC\xD0\xB5\xD0\xB6\xD0\xB4\xD1\u0192 \xD0\xB1\xD1\u0192\xD0\xBA\xD0\xB2\xD0\xB8\xD1\u201A\xD0\xB5","Line Height":"\xD0\u2019\xD0\xB8\xD1\x81\xD0\xBE\xD1\u2021\xD0\xB8\xD0\xBD\xD0\xB0 \xD0\xBD\xD0\xB0 \xD1\u20AC\xD0\xB5\xD0\xB4\xD0\xB0","Font Weight":"\xD0\u201D\xD0\xB5\xD0\xB1\xD0\xB5\xD0\xBB\xD0\xB8\xD0\xBD\xD0\xB0 \xD0\xBD\xD0\xB0 \xD1\u02C6\xD1\u20AC\xD0\xB8\xD1\u201E\xD1\u201A\xD0\xB0","Dyslexia Font":"\xD0\xA8\xD1\u20AC\xD0\xB8\xD1\u201E\xD1\u201A \xD0\xB7\xD0\xB0 \xD0\xB4\xD0\xB8\xD1\x81\xD0\xBB\xD0\xB5\xD0\xBA\xD1\x81\xD0\xB8\xD1\x8F","Language":"\xD0\u2022\xD0\xB7\xD0\xB8\xD0\xBA","Open Accessibility Menu":"\xD0\u017E\xD1\u201A\xD0\xB2\xD0\xBE\xD1\u20AC\xD0\xB8 \xD0\xBC\xD0\xB5\xD0\xBD\xD1\u017D \xD0\xB7\xD0\xB0 \xD0\xB4\xD0\xBE\xD1\x81\xD1\u201A\xD1\u0160\xD0\xBF\xD0\xBD\xD0\xBE\xD1\x81\xD1\u201A"}'
    ),
    bn: JSON.parse(
      '{"Accessibility Menu":"\xE0\xA6\u2026\xE0\xA6\xAD\xE0\xA6\xBF\xE0\xA6\u2014\xE0\xA6\xAE\xE0\xA7\x8D\xE0\xA6\xAF\xE0\xA6\xA4\xE0\xA6\xBE \xE0\xA6\xAE\xE0\xA7\u2021\xE0\xA6\xA8\xE0\xA7\x81","Reset settings":"\xE0\xA6\xA8\xE0\xA6\xBF\xE0\xA6\xB0\xE0\xA7\x8D\xE0\xA6\xA7\xE0\xA6\xBE\xE0\xA6\xB0\xE0\xA6\xA3 \xE0\xA6\xAA\xE0\xA7\x81\xE0\xA6\xA8\xE0\xA6\xB0\xE0\xA6\xBE\xE0\xA6\xAF\xE0\xA6\xBC \xE0\xA6\xB8\xE0\xA7\u2021\xE0\xA6\u0178 \xE0\xA6\u2022\xE0\xA6\xB0\xE0\xA7\x81\xE0\xA6\xA8","Close":"\xE0\xA6\xAC\xE0\xA6\xA8\xE0\xA7\x8D\xE0\xA6\xA7 \xE0\xA6\u2022\xE0\xA6\xB0\xE0\xA7\x81\xE0\xA6\xA8","Content Adjustments":"\xE0\xA6\u2022\xE0\xA6\xA8\xE0\xA7\x8D\xE0\xA6\u0178\xE0\xA7\u2021\xE0\xA6\xA8\xE0\xA7\x8D\xE0\xA6\u0178 \xE0\xA6\xB8\xE0\xA6\u201A\xE0\xA6\xB6\xE0\xA7\u2039\xE0\xA6\xA7\xE0\xA6\xA8","Adjust Font Size":"\xE0\xA6\xAB\xE0\xA6\xA8\xE0\xA7\x8D\xE0\xA6\u0178 \xE0\xA6\xB8\xE0\xA6\xBE\xE0\xA6\u2021\xE0\xA6\u0153 \xE0\xA6\xB8\xE0\xA6\u201A\xE0\xA6\xB6\xE0\xA7\u2039\xE0\xA6\xA7\xE0\xA6\xA8","Highlight Title":"\xE0\xA6\xB6\xE0\xA6\xBF\xE0\xA6\xB0\xE0\xA7\u2039\xE0\xA6\xA8\xE0\xA6\xBE\xE0\xA6\xAE \xE0\xA6\u2030\xE0\xA6\u0153\xE0\xA7\x8D\xE0\xA6\u0153\xE0\xA7\x8D\xE0\xA6\xAC\xE0\xA6\xB2 \xE0\xA6\u2022\xE0\xA6\xB0\xE0\xA7\x81\xE0\xA6\xA8","Highlight Links":"\xE0\xA6\xB2\xE0\xA6\xBF\xE0\xA6\u2122\xE0\xA7\x8D\xE0\xA6\u2022\xE0\xA6\u2014\xE0\xA7\x81\xE0\xA6\xB2\xE0\xA6\xBF \xE0\xA6\u2030\xE0\xA6\u0153\xE0\xA7\x8D\xE0\xA6\u0153\xE0\xA7\x8D\xE0\xA6\xAC\xE0\xA6\xB2 \xE0\xA6\u2022\xE0\xA6\xB0\xE0\xA7\x81\xE0\xA6\xA8","Readable Font":"\xE0\xA6\xAA\xE0\xA6 \xE0\xA6\xA8\xE0\xA7\u20AC\xE0\xA6\xAF\xE0\xA6\xBC \xE0\xA6\xAB\xE0\xA6\xA8\xE0\xA7\x8D\xE0\xA6\u0178","Color Adjustments":"\xE0\xA6\xB0\xE0\xA6\u2122 \xE0\xA6\xB8\xE0\xA6\u201A\xE0\xA6\xB6\xE0\xA7\u2039\xE0\xA6\xA7\xE0\xA6\xA8","Dark Contrast":"\xE0\xA6\u2026\xE0\xA6\xA8\xE0\xA7\x8D\xE0\xA6\xA7\xE0\xA6\u2022\xE0\xA6\xBE\xE0\xA6\xB0\xE0\xA7\u20AC \xE0\xA6\xAA\xE0\xA7\x8D\xE0\xA6\xB0\xE0\xA6\xA4\xE0\xA6\xBF\xE0\xA6\xAC\xE0\xA6\xBF\xE0\xA6\xAE\xE0\xA7\x8D\xE0\xA6\xAC","Light Contrast":"\xE0\xA6\u2020\xE0\xA6\xB2\xE0\xA7\u2039\xE0\xA6\u2022\xE0\xA6\xBF\xE0\xA6\xA4 \xE0\xA6\xAA\xE0\xA7\x8D\xE0\xA6\xB0\xE0\xA6\xA4\xE0\xA6\xBF\xE0\xA6\xAC\xE0\xA6\xBF\xE0\xA6\xAE\xE0\xA7\x8D\xE0\xA6\xAC","High Contrast":"\xE0\xA6\u2030\xE0\xA6\u0161\xE0\xA7\x8D\xE0\xA6\u0161 \xE0\xA6\xAA\xE0\xA7\x8D\xE0\xA6\xB0\xE0\xA6\xA4\xE0\xA6\xBF\xE0\xA6\xAC\xE0\xA6\xBF\xE0\xA6\xAE\xE0\xA7\x8D\xE0\xA6\xAC","High Saturation":"\xE0\xA6\u2030\xE0\xA6\u0161\xE0\xA7\x8D\xE0\xA6\u0161 \xE0\xA6\xB8\xE0\xA6\xA4\xE0\xA7\x8D\xE0\xA6\xB0\xE0\xA6\xBE\xE0\xA6\u0153\xE0\xA6\xA8","Low Saturation":"\xE0\xA6\xA8\xE0\xA6\xBF\xE0\xA6\xAE\xE0\xA7\x8D\xE0\xA6\xA8 \xE0\xA6\xB8\xE0\xA6\xA4\xE0\xA7\x8D\xE0\xA6\xB0\xE0\xA6\xBE\xE0\xA6\u0153\xE0\xA6\xA8","Monochrome":"\xE0\xA6\x8F\xE0\xA6\u2022\xE0\xA6\xB0\xE0\xA6\u2122","Tools":"\xE0\xA6\xB8\xE0\xA6\xB0\xE0\xA6\u017E\xE0\xA7\x8D\xE0\xA6\u0153\xE0\xA6\xBE\xE0\xA6\xAE","Reading Guide":"\xE0\xA6\xAA\xE0\xA6\xA1\xE0\xA6\xBC\xE0\xA6\xBE\xE0\xA6\xB0 \xE0\xA6\u2014\xE0\xA6\xBE\xE0\xA6\u2021\xE0\xA6\xA1","Stop Animations":"\xE0\xA6\u2026\xE0\xA7\x8D\xE0\xA6\xAF\xE0\xA6\xBE\xE0\xA6\xA8\xE0\xA6\xBF\xE0\xA6\xAE\xE0\xA7\u2021\xE0\xA6\xB6\xE0\xA6\xA8 \xE0\xA6\xAC\xE0\xA6\xA8\xE0\xA7\x8D\xE0\xA6\xA7 \xE0\xA6\u2022\xE0\xA6\xB0\xE0\xA7\x81\xE0\xA6\xA8","Big Cursor":"\xE0\xA6\xAC\xE0\xA6\xA1\xE0\xA6\xBC \xE0\xA6\u2022\xE0\xA6\xBE\xE0\xA6\xB0\xE0\xA7\x8D\xE0\xA6\xB8\xE0\xA6\xB0","Increase Font Size":"\xE0\xA6\xAB\xE0\xA6\xA8\xE0\xA7\x8D\xE0\xA6\u0178 \xE0\xA6\xB8\xE0\xA6\xBE\xE0\xA6\u2021\xE0\xA6\u0153 \xE0\xA6\xAC\xE0\xA6\xBE\xE0\xA6\xA1\xE0\xA6\xBC\xE0\xA6\xBE\xE0\xA6\xA8","Decrease Font Size":"\xE0\xA6\xAB\xE0\xA6\xA8\xE0\xA7\x8D\xE0\xA6\u0178 \xE0\xA6\xB8\xE0\xA6\xBE\xE0\xA6\u2021\xE0\xA6\u0153 \xE0\xA6\u2022\xE0\xA6\xAE\xE0\xA6\xBE\xE0\xA6\xA8","Letter Spacing":"\xE0\xA6\u2026\xE0\xA6\u2022\xE0\xA7\x8D\xE0\xA6\xB7\xE0\xA6\xB0 \xE0\xA6\xAC\xE0\xA6\xBF\xE0\xA6\xB0\xE0\xA6\xBE\xE0\xA6\u0178\xE0\xA6\xBF","Line Height":"\xE0\xA6\xB2\xE0\xA6\xBE\xE0\xA6\u2021\xE0\xA6\xA8 \xE0\xA6\u2030\xE0\xA6\u0161\xE0\xA7\x8D\xE0\xA6\u0161\xE0\xA6\xA4\xE0\xA6\xBE","Font Weight":"\xE0\xA6\xAB\xE0\xA6\xA8\xE0\xA7\x8D\xE0\xA6\u0178 \xE0\xA6\u201C\xE0\xA6\u0153\xE0\xA6\xA8","Dyslexia Font":"\xE0\xA6\xA1\xE0\xA6\xBE\xE0\xA6\u2021\xE0\xA6\xB8\xE0\xA6\xB2\xE0\xA7\u2021\xE0\xA6\u2022\xE0\xA7\x8D\xE0\xA6\xB8\xE0\xA6\xBF\xE0\xA6\xAF\xE0\xA6\xBC\xE0\xA6\xBE \xE0\xA6\xAB\xE0\xA6\xA8\xE0\xA7\x8D\xE0\xA6\u0178","Language":"\xE0\xA6\xAD\xE0\xA6\xBE\xE0\xA6\xB7\xE0\xA6\xBE","Open Accessibility Menu":"\xE0\xA6\u2026\xE0\xA6\xAD\xE0\xA6\xBF\xE0\xA6\u2014\xE0\xA6\xAE\xE0\xA7\x8D\xE0\xA6\xAF\xE0\xA6\xA4\xE0\xA6\xBE \xE0\xA6\xAE\xE0\xA7\u2021\xE0\xA6\xA8\xE0\xA7\x81 \xE0\xA6\u2013\xE0\xA7\u2039\xE0\xA6\xB2\xE0\xA7\x81\xE0\xA6\xA8"}'
    ),
    cs: JSON.parse(
      '{"Accessibility Menu":"P\xC5\u2122ístupnostní menu","Reset settings":"Obnovit nastavení","Close":"Zav\xC5\u2122ít","Content Adjustments":"\xC3\u0161pravy obsahu","Adjust Font Size":"Nastavit velikost písma","Highlight Title":"Zv\xC3\xBDraznit nadpis","Highlight Links":"Zv\xC3\xBDraznit odkazy","Readable Font":"\xC4\u0152iteln\xC3\xBD font","Color Adjustments":"Nastavení barev","Dark Contrast":"Tmav\xC3\xBD kontrast","Light Contrast":"Sv\xC4\u203Atl\xC3\xBD kontrast","High Contrast":"Vysok\xC3\xBD kontrast","High Saturation":"Vysok\xC3\xA1 saturace","Low Saturation":"Nízk\xC3\xA1 saturace","Monochrome":"Monochromatick\xC3\xBD","Tools":"N\xC3\xA1stroje","Reading Guide":"Pr\xC5\xAFvodce \xC4\x8Dtením","Stop Animations":"Zastavit animace","Big Cursor":"Velk\xC3\xBD kurzor","Increase Font Size":"Zv\xC4\u203At\xC5\xA1it velikost písma","Decrease Font Size":"Zmen\xC5\xA1it velikost písma","Letter Spacing":"Mezery mezi písmeny","Line Height":"V\xC3\xBD\xC5\xA1ka \xC5\u2122\xC3\xA1dku","Font Weight":"Tlou\xC5\xA1\xC5\xA5ka písma","Dyslexia Font":"Dyslexick\xC3\xBD font","Language":"Jazyk","Open Accessibility Menu":"Otev\xC5\u2122ít p\xC5\u2122ístupnostní menu"}'
    ),
    de: JSON.parse(
      '{"Accessibility Menu":"Barrierefreiheit","Reset settings":"Einstellungen zur\xC3\xBCcksetzen","Close":"Schlie\xC3\u0178en","Content Adjustments":"Inhaltsanpassungen","Adjust Font Size":"Schriftgr\xC3\xB6\xC3\u0178e anpassen","Highlight Title":"Titel hervorheben","Highlight Links":"Links hervorheben","Readable Font":"Lesbare Schrift","Color Adjustments":"Farbanpassungen","Dark Contrast":"Dunkler Kontrast","Light Contrast":"Heller Kontrast","High Contrast":"Hoher Kontrast","High Saturation":"Hohe Farbs\xC3\xA4ttigung","Low Saturation":"Niedrige Farbs\xC3\xA4ttigung","Monochrome":"Monochrom","Tools":"Werkzeuge","Reading Guide":"Lesehilfe","Stop Animations":"Animationen stoppen","Big Cursor":"Gro\xC3\u0178er Cursor","Increase Font Size":"Schriftgr\xC3\xB6\xC3\u0178e vergr\xC3\xB6\xC3\u0178ern","Decrease Font Size":"Schriftgr\xC3\xB6\xC3\u0178e verkleinern","Letter Spacing":"Zeichenabstand","Line Height":"Zeilenh\xC3\xB6he","Font Weight":"Schriftst\xC3\xA4rke","Dyslexia Font":"Dyslexie-Schrift","Language":"Sprache","Open Accessibility Menu":"Barrierefreiheitsmen\xC3\xBC \xC3\xB6ffnen"}'
    ),
    el: JSON.parse(
      '{"Accessibility Menu":"\xCE\u0153\xCE\xB5\xCE\xBD\xCE\xBF\xCF\x8D \xCF\u20AC\xCF\x81\xCE\xBF\xCF\u0192\xCE\xB2\xCE\xB1\xCF\u0192\xCE\xB9\xCE\xBC\xCF\u0152\xCF\u201E\xCE\xB7\xCF\u201E\xCE\xB1\xCF\u201A","Reset settings":"\xCE\u2022\xCF\u20AC\xCE\xB1\xCE\xBD\xCE\xB1\xCF\u2020\xCE\xBF\xCF\x81\xCE\xAC \xCF\x81\xCF\u2026\xCE\xB8\xCE\xBC\xCE\xAF\xCF\u0192\xCE\xB5\xCF\u2030\xCE\xBD","Close":"\xCE\u0161\xCE\xBB\xCE\xB5\xCE\xAF\xCF\u0192\xCE\xB9\xCE\xBC\xCE\xBF","Content Adjustments":"\xCE \xCF\x81\xCE\xBF\xCF\u0192\xCE\xB1\xCF\x81\xCE\xBC\xCE\xBF\xCE\xB3\xCE\xAD\xCF\u201A \xCF\u20AC\xCE\xB5\xCF\x81\xCE\xB9\xCE\xB5\xCF\u2021\xCE\xBF\xCE\xBC\xCE\xAD\xCE\xBD\xCE\xBF\xCF\u2026","Adjust Font Size":"\xCE \xCF\x81\xCE\xBF\xCF\u0192\xCE\xB1\xCF\x81\xCE\xBC\xCE\xBF\xCE\xB3\xCE\xAE \xCE\xBC\xCE\xB5\xCE\xB3\xCE\xAD\xCE\xB8\xCE\xBF\xCF\u2026\xCF\u201A \xCE\xB3\xCF\x81\xCE\xB1\xCE\xBC\xCE\xBC\xCE\xB1\xCF\u201E\xCE\xBF\xCF\u0192\xCE\xB5\xCE\xB9\xCF\x81\xCE\xAC\xCF\u201A","Highlight Title":"\xCE\u2022\xCF\u20AC\xCE\xB9\xCF\u0192\xCE\xAE\xCE\xBC\xCE\xB1\xCE\xBD\xCF\u0192\xCE\xB7 \xCF\u201E\xCE\xAF\xCF\u201E\xCE\xBB\xCE\xBF\xCF\u2026","Highlight Links":"\xCE\u2022\xCF\u20AC\xCE\xB9\xCF\u0192\xCE\xAE\xCE\xBC\xCE\xB1\xCE\xBD\xCF\u0192\xCE\xB7 \xCF\u0192\xCF\u2026\xCE\xBD\xCE\xB4\xCE\xAD\xCF\u0192\xCE\xBC\xCF\u2030\xCE\xBD","Readable Font":"\xCE\u2022\xCF\u2026\xCE\xB1\xCE\xBD\xCE\xAC\xCE\xB3\xCE\xBD\xCF\u2030\xCF\u0192\xCF\u201E\xCE\xB7 \xCE\xB3\xCF\x81\xCE\xB1\xCE\xBC\xCE\xBC\xCE\xB1\xCF\u201E\xCE\xBF\xCF\u0192\xCE\xB5\xCE\xB9\xCF\x81\xCE\xAC","Color Adjustments":"\xCE \xCF\x81\xCE\xBF\xCF\u0192\xCE\xB1\xCF\x81\xCE\xBC\xCE\xBF\xCE\xB3\xCE\xAD\xCF\u201A \xCF\u2021\xCF\x81\xCF\u2030\xCE\xBC\xCE\xAC\xCF\u201E\xCF\u2030\xCE\xBD","Dark Contrast":"\xCE\u2018\xCE\xBD\xCF\u201E\xCE\xAF\xCE\xB8\xCE\xB5\xCF\u0192\xCE\xB7 \xCF\u0192\xCE\xB5 \xCF\u0192\xCE\xBA\xCE\xBF\xCF\x8D\xCF\x81\xCE\xBF","Light Contrast":"\xCE\u2018\xCE\xBD\xCF\u201E\xCE\xAF\xCE\xB8\xCE\xB5\xCF\u0192\xCE\xB7 \xCF\u0192\xCE\xB5 \xCF\u2020\xCF\u2030\xCF\u201E\xCE\xB5\xCE\xB9\xCE\xBD\xCF\u0152","High Contrast":"\xCE\xA5\xCF\u02C6\xCE\xB7\xCE\xBB\xCE\xAE \xCE\xB1\xCE\xBD\xCF\u201E\xCE\xAF\xCE\xB8\xCE\xB5\xCF\u0192\xCE\xB7","High Saturation":"\xCE\xA5\xCF\u02C6\xCE\xB7\xCE\xBB\xCF\u0152\xCF\u201A \xCE\xBA\xCE\xBF\xCF\x81\xCE\xB5\xCF\u0192\xCE\xBC\xCF\u0152\xCF\u201A","Low Saturation":"\xCE\xA7\xCE\xB1\xCE\xBC\xCE\xB7\xCE\xBB\xCF\u0152\xCF\u201A \xCE\xBA\xCE\xBF\xCF\x81\xCE\xB5\xCF\u0192\xCE\xBC\xCF\u0152\xCF\u201A","Monochrome":"\xCE\u0153\xCE\xBF\xCE\xBD\xCF\u0152\xCF\u2021\xCF\x81\xCF\u2030\xCE\xBC\xCE\xBF","Tools":"\xCE\u2022\xCF\x81\xCE\xB3\xCE\xB1\xCE\xBB\xCE\xB5\xCE\xAF\xCE\xB1","Reading Guide":"\xCE\u0178\xCE\xB4\xCE\xB7\xCE\xB3\xCF\u0152\xCF\u201A \xCE\xB1\xCE\xBD\xCE\xAC\xCE\xB3\xCE\xBD\xCF\u2030\xCF\u0192\xCE\xB7\xCF\u201A","Stop Animations":"\xCE\u2018\xCF\u2020\xCE\xB1\xCE\xAF\xCF\x81\xCE\xB5\xCF\u0192\xCE\xB7 \xCE\xBA\xCE\xAF\xCE\xBD\xCE\xB7\xCF\u0192\xCE\xB7\xCF\u201A","Big Cursor":"\xCE\u0153\xCE\xB5\xCE\xB3\xCE\xAC\xCE\xBB\xCE\xBF\xCF\u201A \xCE\xB4\xCE\xB5\xCE\xAF\xCE\xBA\xCF\u201E\xCE\xB7\xCF\u201A","Increase Font Size":"\xCE\u2018\xCF\x8D\xCE\xBE\xCE\xB7\xCF\u0192\xCE\xB7 \xCE\xBC\xCE\xB5\xCE\xB3\xCE\xAD\xCE\xB8\xCE\xBF\xCF\u2026\xCF\u201A \xCE\xB3\xCF\x81\xCE\xB1\xCE\xBC\xCE\xBC\xCE\xB1\xCF\u201E\xCE\xBF\xCF\u0192\xCE\xB5\xCE\xB9\xCF\x81\xCE\xAC\xCF\u201A","Decrease Font Size":"\xCE\u0153\xCE\xB5\xCE\xAF\xCF\u2030\xCF\u0192\xCE\xB7 \xCE\xBC\xCE\xB5\xCE\xB3\xCE\xAD\xCE\xB8\xCE\xBF\xCF\u2026\xCF\u201A \xCE\xB3\xCF\x81\xCE\xB1\xCE\xBC\xCE\xBC\xCE\xB1\xCF\u201E\xCE\xBF\xCF\u0192\xCE\xB5\xCE\xB9\xCF\x81\xCE\xAC\xCF\u201A","Letter Spacing":"\xCE\u201D\xCE\xB9\xCE\xAC\xCE\xBA\xCE\xB5\xCE\xBD\xCE\xBF \xCE\xB3\xCF\x81\xCE\xB1\xCE\xBC\xCE\xBC\xCE\xAC\xCF\u201E\xCF\u2030\xCE\xBD","Line Height":"\xCE\xA5\xCF\u02C6\xCE\xBF\xCF\u201A \xCE\xB3\xCF\x81\xCE\xB1\xCE\xBC\xCE\xBC\xCE\xAE\xCF\u201A","Font Weight":"\xCE\u2019\xCE\xAC\xCF\x81\xCE\xBF\xCF\u201A \xCE\xB3\xCF\x81\xCE\xB1\xCE\xBC\xCE\xBC\xCE\xB1\xCF\u201E\xCE\xBF\xCF\u0192\xCE\xB5\xCE\xB9\xCF\x81\xCE\xAC\xCF\u201A","Dyslexia Font":"\xCE\u201C\xCF\x81\xCE\xB1\xCE\xBC\xCE\xBC\xCE\xB1\xCF\u201E\xCE\xBF\xCF\u0192\xCE\xB5\xCE\xB9\xCF\x81\xCE\xAC \xCE\xB3\xCE\xB9\xCE\xB1 \xCE\xB4\xCF\u2026\xCF\u0192\xCE\xBB\xCE\xB5\xCE\xBE\xCE\xAF\xCE\xB1","Language":"\xCE\u201C\xCE\xBB\xCF\u017D\xCF\u0192\xCF\u0192\xCE\xB1","Open Accessibility Menu":"\xCE\u2018\xCE\xBD\xCE\xBF\xCE\xAF\xCE\xBE\xCF\u201E\xCE\xB5 \xCF\u201E\xCE\xBF \xCE\xBC\xCE\xB5\xCE\xBD\xCE\xBF\xCF\x8D \xCF\u20AC\xCF\x81\xCE\xBF\xCF\u0192\xCE\xB2\xCE\xB1\xCF\u0192\xCE\xB9\xCE\xBC\xCF\u0152\xCF\u201E\xCE\xB7\xCF\u201E\xCE\xB1\xCF\u201A"}'
    ),
    en: JSON.parse(
      '{"Accessibility Menu":"Accessibility Menu","Reset settings":"Reset settings","Close":"Close","Content Adjustments":"Content Adjustments","Adjust Font Size":"Adjust Font Size","Highlight Title":"Highlight Title","Highlight Links":"Highlight Links","Readable Font":"Readable Font","Color Adjustments":"Color Adjustments","Dark Contrast":"Dark Contrast","Light Contrast":"Light Contrast","High Contrast":"High Contrast","High Saturation":"High Saturation","Low Saturation":"Low Saturation","Monochrome":"Monochrome","Tools":"Tools","Reading Guide":"Reading Guide","Stop Animations":"Stop Animations","Big Cursor":"Big Cursor","Increase Font Size":"Increase Font Size","Decrease Font Size":"Decrease Font Size","Letter Spacing":"Letter Spacing","Line Height":"Line Height","Font Weight":"Font Weight","Dyslexia Font":"Dyslexia Font","Language":"Language","Open Accessibility Menu":"Open Accessibility Menu"}'
    ),
    es: JSON.parse(
      '{"Accessibility Menu":"Menú de accesibilidad","Reset settings":"Restablecer configuración","Close":"Cerrar","Content Adjustments":"Ajustes de contenido","Adjust Font Size":"Ajustar el tamaño de fuente","Highlight Title":"Destacar título","Highlight Links":"Destacar enlaces","Readable Font":"Fuente legible","Color Adjustments":"Ajustes de color","Dark Contrast":"Contraste oscuro","Light Contrast":"Contraste claro","High Contrast":"Alto contraste","High Saturation":"Alta saturación","Low Saturation":"Baja saturación","Monochrome":"Monocromo","Tools":"Herramientas","Reading Guide":"Guía de lectura","Stop Animations":"Detener animaciones","Big Cursor":"Cursor grande","Increase Font Size":"Aumentar tamaño de fuente","Decrease Font Size":"Reducir tamaño de fuente","Letter Spacing":"Espaciado entre letras","Line Height":"Altura de línea","Font Weight":"Grosor de fuente","Dyslexia Font":"Fuente para dislexia","Language":"Idioma","Open Accessibility Menu":"Abrir menú de accesibilidad"}'
    ),
    fi: JSON.parse(
      '{"Accessibility Menu":"Saavutettavuusvalikko","Reset settings":"Palauta asetukset","Close":"Sulje","Content Adjustments":"Sis\xC3\xA4ll\xC3\xB6n s\xC3\xA4\xC3\xA4d\xC3\xB6t","Adjust Font Size":"S\xC3\xA4\xC3\xA4d\xC3\xA4 fonttikokoa","Highlight Title":"Korosta otsikko","Highlight Links":"Korosta linkit","Readable Font":"Helposti luettava fontti","Color Adjustments":"V\xC3\xA4rien s\xC3\xA4\xC3\xA4d\xC3\xB6t","Dark Contrast":"Tumma kontrasti","Light Contrast":"Vaalea kontrasti","High Contrast":"Korkea kontrasti","High Saturation":"Korkea kyll\xC3\xA4isyys","Low Saturation":"Matala kyll\xC3\xA4isyys","Monochrome":"Yksiv\xC3\xA4rinen","Tools":"Ty\xC3\xB6kalut","Reading Guide":"Lukemisopas","Stop Animations":"Pys\xC3\xA4yt\xC3\xA4 animaatiot","Big Cursor":"Iso kohdistin","Increase Font Size":"Suurenna fonttikokoa","Decrease Font Size":"Pienenn\xC3\xA4 fonttikokoa","Letter Spacing":"Kirjainten v\xC3\xA4listys","Line Height":"Rivin korkeus","Font Weight":"Fontin paksuus","Dyslexia Font":"Dysleksiafontti","Language":"Kieli","Open Accessibility Menu":"Avaa saavutettavuusvalikko"}'
    ),
    fr: JSON.parse(
      '{"Accessibility Menu":"Menu d\'accessibilit\xC3\xA9","Reset settings":"R\xC3\xA9initialiser les param\xC3\xA8tres","Close":"Fermer","Content Adjustments":"Ajustements de contenu","Adjust Font Size":"Ajuster la taille de police","Highlight Title":"Surligner le titre","Highlight Links":"Surligner les liens","Readable Font":"Police lisible","Color Adjustments":"Ajustements de couleur","Dark Contrast":"Contraste fonc\xC3\xA9","Light Contrast":"Contraste clair","High Contrast":"Contraste \xC3\xA9lev\xC3\xA9","High Saturation":"Saturation \xC3\xA9lev\xC3\xA9e","Low Saturation":"Saturation faible","Monochrome":"Monochrome","Tools":"Outils","Reading Guide":"Guide de lecture","Stop Animations":"Arr\xC3\xAAter les animations","Big Cursor":"Gros curseur","Increase Font Size":"Augmenter la taille de police","Decrease Font Size":"R\xC3\xA9duire la taille de police","Letter Spacing":"Espacement des lettres","Line Height":"Hauteur de ligne","Font Weight":"Poids de la police","Dyslexia Font":"Police dyslexie","Language":"Langue","Open Accessibility Menu":"Ouvrir le menu d\'accessibilit\xC3\xA9"}'
    ),
    he: JSON.parse(
      '{"Accessibility Menu":"\xD7\xAA\xD7\xA4\xD7\xA8\xD7\u2122\xD7\u02DC \xD7 \xD7\u2019\xD7\u2122\xD7\xA9\xD7\u2022\xD7\xAA","Reset settings":"\xD7\x90\xD7\u2122\xD7\xA4\xD7\u2022\xD7\xA1 \xD7\u201D\xD7\u2019\xD7\u201C\xD7\xA8\xD7\u2022\xD7\xAA","Close":"\xD7\xA1\xD7\u2019\xD7\u2022\xD7\xA8","Content Adjustments":"\xD7\u201D\xD7\xAA\xD7\x90\xD7\u017E\xD7\u2022\xD7\xAA \xD7\xAA\xD7\u2022\xD7\u203A\xD7\u0178","Adjust Font Size":"\xD7\u201D\xD7\xAA\xD7\x90\xD7\x9D \xD7\u2019\xD7\u2022\xD7\u201C\xD7\u0153 \xD7\xA4\xD7\u2022\xD7 \xD7\u02DC","Highlight Title":"\xD7\u201D\xD7\u201C\xD7\u2019\xD7\xA9 \xD7\u203A\xD7\u2022\xD7\xAA\xD7\xA8\xD7\xAA","Highlight Links":"\xD7\u201D\xD7\u201C\xD7\u2019\xD7\xA9 \xD7\xA7\xD7\u2122\xD7\xA9\xD7\u2022\xD7\xA8\xD7\u2122\xD7\x9D","Readable Font":"\xD7\xA4\xD7\u2022\xD7 \xD7\u02DC \xD7\xA7\xD7\xA8\xD7\u2122\xD7\x90","Color Adjustments":"\xD7\u201D\xD7\xAA\xD7\x90\xD7\u017E\xD7\u2022\xD7\xAA \xD7\xA6\xD7\u2018\xD7\xA2","Dark Contrast":"\xD7 \xD7\u2122\xD7\u2019\xD7\u2022\xD7\u201C\xD7\u2122\xD7\u2022\xD7\xAA \xD7\u203A\xD7\u201D\xD7\u201D","Light Contrast":"\xD7 \xD7\u2122\xD7\u2019\xD7\u2022\xD7\u201C\xD7\u2122\xD7\u2022\xD7\xAA \xD7\u2018\xD7\u201D\xD7\u2122\xD7\xA8\xD7\u201D","High Contrast":"\xD7 \xD7\u2122\xD7\u2019\xD7\u2022\xD7\u201C\xD7\u2122\xD7\u2022\xD7\xAA \xD7\u2019\xD7\u2018\xD7\u2022\xD7\u201D\xD7\u201D","High Saturation":"\xD7\xA8\xD7\u2022\xD7\u2022\xD7\u2122 \xD7\xA6\xD7\u2018\xD7\xA2 \xD7\u2019\xD7\u2018\xD7\u2022\xD7\u201D","Low Saturation":"\xD7\xA8\xD7\u2022\xD7\u2022\xD7\u2122 \xD7\xA6\xD7\u2018\xD7\xA2 \xD7 \xD7\u017E\xD7\u2022\xD7\u0161","Monochrome":"\xD7\u017E\xD7\u2022\xD7 \xD7\u2022\xD7\u203A\xD7\xA8\xD7\u2022\xD7\x9D","Tools":"\xD7\u203A\xD7\u0153\xD7\u2122\xD7\x9D","Reading Guide":"\xD7\u017E\xD7\u201C\xD7\xA8\xD7\u2122\xD7\u0161 \xD7\xA7\xD7\xA8\xD7\u2122\xD7\x90\xD7\u201D","Stop Animations":"\xD7\xA2\xD7\xA6\xD7\u2122\xD7\xA8\xD7\xAA \xD7\x90\xD7 \xD7\u2122\xD7\u017E\xD7\xA6\xD7\u2122\xD7\u2022\xD7\xAA","Big Cursor":"\xD7\xA1\xD7\u017E\xD7\u0178 \xD7\u2019\xD7\u201C\xD7\u2022\xD7\u0153","Increase Font Size":"\xD7\u201D\xD7\u2019\xD7\u201C\xD7\u0153 \xD7\u2019\xD7\u2022\xD7\u201C\xD7\u0153 \xD7\xA4\xD7\u2022\xD7 \xD7\u02DC","Decrease Font Size":"\xD7\u201D\xD7\xA7\xD7\u02DC\xD7\u0178 \xD7\u2019\xD7\u2022\xD7\u201C\xD7\u0153 \xD7\xA4\xD7\u2022\xD7 \xD7\u02DC","Letter Spacing":"\xD7\u017E\xD7\xA8\xD7\u2022\xD7\u2022\xD7\u2014 \xD7\u2018\xD7\u2122\xD7\u0178 \xD7\x90\xD7\u2022\xD7\xAA\xD7\u2122\xD7\u2022\xD7\xAA","Line Height":"\xD7\u2019\xD7\u2022\xD7\u2018\xD7\u201D \xD7\xA9\xD7\u2022\xD7\xA8\xD7\u201D","Font Weight":"\xD7\u017E\xD7\xA9\xD7\xA7\xD7\u0153 \xD7\u201D\xD7\xA4\xD7\u2022\xD7 \xD7\u02DC","Dyslexia Font":"\xD7\xA4\xD7\u2022\xD7 \xD7\u02DC \xD7\u0153\xD7\u201C\xD7\u2122\xD7\xA1\xD7\u0153\xD7\xA7\xD7\u02DC\xD7\u2122\xD7\x9D","Language":"\xD7\xA9\xD7\xA4\xD7\u201D","Open Accessibility Menu":"\xD7\xA4\xD7\xAA\xD7\u2014 \xD7\xAA\xD7\xA4\xD7\xA8\xD7\u2122\xD7\u02DC \xD7 \xD7\u2019\xD7\u2122\xD7\xA9\xD7\u2022\xD7\xAA"}'
    ),
    hi: JSON.parse(
      '{"Accessibility Menu":"\xE0\xA4\xAA\xE0\xA4\xB9\xE0\xA5\x81\xE0\xA4\x81\xE0\xA4\u0161\xE0\xA4\xBF\xE0\xA4\xAF\xE0\xA5\u2039\xE0\xA4\u2014\xE0\xA5\x8D\xE0\xA4\xAF\xE0\xA4\xA4\xE0\xA4\xBE \xE0\xA4\xAE\xE0\xA5\u2021\xE0\xA4\xA8\xE0\xA5\u201A","Reset settings":"\xE0\xA4\xB8\xE0\xA5\u2021\xE0\xA4\u0178\xE0\xA4\xBF\xE0\xA4\u201A\xE0\xA4\u2014 \xE0\xA4\xB0\xE0\xA5\u20AC\xE0\xA4\xB8\xE0\xA5\u2021\xE0\xA4\u0178 \xE0\xA4\u2022\xE0\xA4\xB0\xE0\xA5\u2021\xE0\xA4\u201A","Close":"\xE0\xA4\xAC\xE0\xA4\u201A\xE0\xA4\xA6 \xE0\xA4\u2022\xE0\xA4\xB0\xE0\xA5\u2021\xE0\xA4\u201A","Content Adjustments":"\xE0\xA4\xB8\xE0\xA4\xBE\xE0\xA4\xAE\xE0\xA4\u2014\xE0\xA5\x8D\xE0\xA4\xB0\xE0\xA5\u20AC \xE0\xA4\xB8\xE0\xA4\xAE\xE0\xA4\xBE\xE0\xA4\xAF\xE0\xA5\u2039\xE0\xA4\u0153\xE0\xA4\xA8","Adjust Font Size":"\xE0\xA4\xAB\xE0\xA4\xBC\xE0\xA5\u2030\xE0\xA4\xA8\xE0\xA5\x8D\xE0\xA4\u0178 \xE0\xA4\u2020\xE0\xA4\u2022\xE0\xA4\xBE\xE0\xA4\xB0 \xE0\xA4\xB8\xE0\xA4\xAE\xE0\xA4\xBE\xE0\xA4\xAF\xE0\xA5\u2039\xE0\xA4\u0153\xE0\xA4\xBF\xE0\xA4\xA4 \xE0\xA4\u2022\xE0\xA4\xB0\xE0\xA5\u2021\xE0\xA4\u201A","Highlight Title":"\xE0\xA4\xB6\xE0\xA5\u20AC\xE0\xA4\xB0\xE0\xA5\x8D\xE0\xA4\xB7\xE0\xA4\u2022 \xE0\xA4\u2022\xE0\xA5\u2039 \xE0\xA4\xB9\xE0\xA4\xBE\xE0\xA4\u2021\xE0\xA4\xB2\xE0\xA4\xBE\xE0\xA4\u2021\xE0\xA4\u0178 \xE0\xA4\u2022\xE0\xA4\xB0\xE0\xA5\u2021\xE0\xA4\u201A","Highlight Links":"\xE0\xA4\xB2\xE0\xA4\xBF\xE0\xA4\u201A\xE0\xA4\u2022 \xE0\xA4\u2022\xE0\xA5\u2039 \xE0\xA4\xB9\xE0\xA4\xBE\xE0\xA4\u2021\xE0\xA4\xB2\xE0\xA4\xBE\xE0\xA4\u2021\xE0\xA4\u0178 \xE0\xA4\u2022\xE0\xA4\xB0\xE0\xA5\u2021\xE0\xA4\u201A","Readable Font":"\xE0\xA4\xAA\xE0\xA4\xA2\xE0\xA4\xBC\xE0\xA4\xA8\xE0\xA5\u2021 \xE0\xA4\xAF\xE0\xA5\u2039\xE0\xA4\u2014\xE0\xA5\x8D\xE0\xA4\xAF \xE0\xA4\xAB\xE0\xA4\xBC\xE0\xA5\u2030\xE0\xA4\xA8\xE0\xA5\x8D\xE0\xA4\u0178","Color Adjustments":"\xE0\xA4\xB0\xE0\xA4\u201A\xE0\xA4\u2014 \xE0\xA4\xB8\xE0\xA4\xAE\xE0\xA4\xBE\xE0\xA4\xAF\xE0\xA5\u2039\xE0\xA4\u0153\xE0\xA4\xA8","Dark Contrast":"\xE0\xA4\u2026\xE0\xA4\u201A\xE0\xA4\xA7\xE0\xA5\u2021\xE0\xA4\xB0\xE0\xA4\xBE \xE0\xA4\xB5\xE0\xA4\xBF\xE0\xA4\xB0\xE0\xA5\u2039\xE0\xA4\xA7","Light Contrast":"\xE0\xA4\xAA\xE0\xA5\x8D\xE0\xA4\xB0\xE0\xA4\u2022\xE0\xA4\xBE\xE0\xA4\xB6 \xE0\xA4\xB5\xE0\xA4\xBF\xE0\xA4\xB0\xE0\xA5\u2039\xE0\xA4\xA7","High Contrast":"\xE0\xA4\u2030\xE0\xA4\u0161\xE0\xA5\x8D\xE0\xA4\u0161 \xE0\xA4\xB5\xE0\xA4\xBF\xE0\xA4\xB0\xE0\xA5\u2039\xE0\xA4\xA7","High Saturation":"\xE0\xA4\u2030\xE0\xA4\u0161\xE0\xA5\x8D\xE0\xA4\u0161 \xE0\xA4\xB8\xE0\xA4\u201A\xE0\xA4\xA4\xE0\xA5\x81\xE0\xA4\xB2\xE0\xA4\xA8","Low Saturation":"\xE0\xA4\xA8\xE0\xA4\xBF\xE0\xA4\xAE\xE0\xA5\x8D\xE0\xA4\xA8 \xE0\xA4\xB8\xE0\xA4\u201A\xE0\xA4\xA4\xE0\xA5\x81\xE0\xA4\xB2\xE0\xA4\xA8","Monochrome":"\xE0\xA4\x8F\xE0\xA4\u2022\xE0\xA4\xB0\xE0\xA4\u201A\xE0\xA4\u2014","Tools":"\xE0\xA4\u2030\xE0\xA4\xAA\xE0\xA4\u2022\xE0\xA4\xB0\xE0\xA4\xA3","Reading Guide":"\xE0\xA4\xAA\xE0\xA4\xA2\xE0\xA4\xBC\xE0\xA4\xA8\xE0\xA5\u2021 \xE0\xA4\u2022\xE0\xA4\xBE \xE0\xA4\u2014\xE0\xA4\xBE\xE0\xA4\u2021\xE0\xA4\xA1","Stop Animations":"\xE0\xA4\x8F\xE0\xA4\xA8\xE0\xA4\xBF\xE0\xA4\xAE\xE0\xA5\u2021\xE0\xA4\xB6\xE0\xA4\xA8 \xE0\xA4\xB0\xE0\xA5\u2039\xE0\xA4\u2022\xE0\xA5\u2021\xE0\xA4\u201A","Big Cursor":"\xE0\xA4\xAC\xE0\xA4\xA1\xE0\xA4\xBC\xE0\xA4\xBE \xE0\xA4\u2022\xE0\xA4\xB0\xE0\xA5\x8D\xE0\xA4\xB8\xE0\xA4\xB0","Increase Font Size":"\xE0\xA4\xAB\xE0\xA4\xBC\xE0\xA5\u2030\xE0\xA4\xA8\xE0\xA5\x8D\xE0\xA4\u0178 \xE0\xA4\u2020\xE0\xA4\u2022\xE0\xA4\xBE\xE0\xA4\xB0 \xE0\xA4\xAC\xE0\xA4\xA2\xE0\xA4\xBC\xE0\xA4\xBE\xE0\xA4\x8F\xE0\xA4\x81","Decrease Font Size":"\xE0\xA4\xAB\xE0\xA4\xBC\xE0\xA5\u2030\xE0\xA4\xA8\xE0\xA5\x8D\xE0\xA4\u0178 \xE0\xA4\u2020\xE0\xA4\u2022\xE0\xA4\xBE\xE0\xA4\xB0 \xE0\xA4\u2022\xE0\xA4\xAE \xE0\xA4\u2022\xE0\xA4\xB0\xE0\xA5\u2021\xE0\xA4\u201A","Letter Spacing":"\xE0\xA4\u2026\xE0\xA4\u2022\xE0\xA5\x8D\xE0\xA4\xB7\xE0\xA4\xB0 \xE0\xA4\xB8\xE0\xA5\x8D\xE0\xA4\xAA\xE0\xA5\u2021\xE0\xA4\xB8\xE0\xA4\xBF\xE0\xA4\u201A\xE0\xA4\u2014","Line Height":"\xE0\xA4\xB2\xE0\xA4\xBE\xE0\xA4\u2021\xE0\xA4\xA8 \xE0\xA4\u2022\xE0\xA5\u20AC \xE0\xA4\u0160\xE0\xA4\x81\xE0\xA4\u0161\xE0\xA4\xBE\xE0\xA4\u02C6","Font Weight":"\xE0\xA4\xAB\xE0\xA4\xBC\xE0\xA5\u2030\xE0\xA4\xA8\xE0\xA5\x8D\xE0\xA4\u0178 \xE0\xA4\xB5\xE0\xA5\u2021\xE0\xA4\u0178","Dyslexia Font":"\xE0\xA4\xB5\xE0\xA4\xBF\xE0\xA4\xB5\xE0\xA4\xBF\xE0\xA4\xA7\xE0\xA4\xA4\xE0\xA4\xBE\xE0\xA4\u0153\xE0\xA4\xA8\xE0\xA4\xBF\xE0\xA4\xA4 \xE0\xA4\xB5\xE0\xA4\xBF\xE0\xA4\xAA\xE0\xA4\xA5\xE0\xA4\xA4\xE0\xA4\xBE \xE0\xA4\xAB\xE0\xA4\xBC\xE0\xA5\u2030\xE0\xA4\xA8\xE0\xA5\x8D\xE0\xA4\u0178","Language":"\xE0\xA4\xAD\xE0\xA4\xBE\xE0\xA4\xB7\xE0\xA4\xBE","Open Accessibility Menu":"\xE0\xA4\x8F\xE0\xA4\u2022\xE0\xA5\x8D\xE0\xA4\xB8\xE0\xA5\u2021\xE0\xA4\xB8\xE0\xA4\xBF\xE0\xA4\xAC\xE0\xA4\xBF\xE0\xA4\xB2\xE0\xA4\xBF\xE0\xA4\u0178\xE0\xA5\u20AC \xE0\xA4\xAE\xE0\xA5\u2021\xE0\xA4\xA8\xE0\xA5\u201A \xE0\xA4\u2013\xE0\xA5\u2039\xE0\xA4\xB2\xE0\xA5\u2021\xE0\xA4\u201A"}'
    ),
    hr: JSON.parse(
      '{"Accessibility Menu":"Izbornik Pristupa\xC4\x8Dnosti","Reset settings":"Resetiraj postavke","Close":"Zatvori","Content Adjustments":"Prilagodbe Sadr\xC5\xBEaja","Adjust Font Size":"Prilagodi Veli\xC4\x8Dinu Fonta","Highlight Title":"Istakni Naslove","Highlight Links":"Istakni Poveznice","Readable Font":"\xC4\u0152itljiv Font","Color Adjustments":"Prilagodbe Boja","Dark Contrast":"Tamni Kontrast","Light Contrast":"Svijetli Kontrast","High Contrast":"Visoki Kontrast","High Saturation":"Visoka Zasi\xC4\u2021enost","Low Saturation":"Niska Zasi\xC4\u2021enost","Monochrome":"Jednobojno","Tools":"Alati","Reading Guide":"Vodi\xC4\x8D Za \xC4\u0152itanje","Stop Animations":"Zaustavi Animacije","Big Cursor":"Veliki Kursor","Increase Font Size":"Pove\xC4\u2021aj Veli\xC4\x8Dinu Fonta","Decrease Font Size":"Smanji Veli\xC4\x8Dinu Fonta","Letter Spacing":"Razmak Izme\xC4\u2018u Slova","Line Height":"Visina Linije","Font Weight":"Debljina Fonta","Dyslexia Font":"Font Za Disleksiju","Language":"Jezik","Open Accessibility Menu":"Otvori Izbornik Pristupa\xC4\x8Dnosti"}'
    ),
    hu: JSON.parse(
      '{"Accessibility Menu":"Hozz\xC3\xA1f\xC3\xA9rhet\xC5\u2018s\xC3\xA9gi men\xC3\xBC","Reset settings":"Be\xC3\xA1llít\xC3\xA1sok vissza\xC3\xA1llít\xC3\xA1sa","Close":"Bez\xC3\xA1r\xC3\xA1s","Content Adjustments":"Tartalom be\xC3\xA1llít\xC3\xA1sai","Adjust Font Size":"Bet\xC5\xB1m\xC3\xA9ret be\xC3\xA1llít\xC3\xA1sa","Highlight Title":"Cím kiemel\xC3\xA9se","Highlight Links":"Linkek kiemel\xC3\xA9se","Readable Font":"Olvasható bet\xC5\xB1típus","Color Adjustments":"Színbe\xC3\xA1llít\xC3\xA1sok","Dark Contrast":"S\xC3\xB6t\xC3\xA9t kontraszt","Light Contrast":"Vil\xC3\xA1gos kontraszt","High Contrast":"Magas kontraszt","High Saturation":"Magas telítetts\xC3\xA9g","Low Saturation":"Alacsony telítetts\xC3\xA9g","Monochrome":"Monokróm","Tools":"Eszk\xC3\xB6z\xC3\xB6k","Reading Guide":"Olvas\xC3\xA1si útmutató","Stop Animations":"Anim\xC3\xA1ciók le\xC3\xA1llít\xC3\xA1sa","Big Cursor":"Nagy kurzor","Increase Font Size":"Bet\xC5\xB1m\xC3\xA9ret n\xC3\xB6vel\xC3\xA9se","Decrease Font Size":"Bet\xC5\xB1m\xC3\xA9ret cs\xC3\xB6kkent\xC3\xA9se","Letter Spacing":"Bet\xC5\xB1t\xC3\xA1vols\xC3\xA1g","Line Height":"Sor magass\xC3\xA1g","Font Weight":"Bet\xC5\xB1típus vastags\xC3\xA1ga","Dyslexia Font":"Dyslexia bet\xC5\xB1típus","Language":"Nyelv","Open Accessibility Menu":"Hozz\xC3\xA1f\xC3\xA9rhet\xC5\u2018s\xC3\xA9gi men\xC3\xBC megnyit\xC3\xA1sa"}'
    ),
    id: JSON.parse(
      '{"Accessibility Menu":"Menu Aksesibilitas","Reset settings":"Atur Ulang Pengaturan","Close":"Tutup","Content Adjustments":"Penyesuaian Konten","Adjust Font Size":"Sesuaikan Ukuran Font","Highlight Title":"Sorot Judul","Highlight Links":"Sorot Tautan","Readable Font":"Font Mudah Dibaca","Color Adjustments":"Penyesuaian Warna","Dark Contrast":"Kontras Gelap","Light Contrast":"Kontras Terang","High Contrast":"Kontras Tinggi","High Saturation":"Saturasi Tinggi","Low Saturation":"Saturasi Rendah","Monochrome":"Monokrom","Tools":"Alat","Reading Guide":"Panduan Membaca","Stop Animations":"Hentikan Animasi","Big Cursor":"Kursor Besar","Increase Font Size":"Perbesar Ukuran Font","Decrease Font Size":"Perkecil Ukuran Font","Letter Spacing":"Jarak Huruf","Line Height":"Tinggi Baris","Font Weight":"Ketebalan Font","Dyslexia Font":"Font Disleksia","Language":"Bahasa","Open Accessibility Menu":"Buka menu aksesibilitas"}'
    ),
    it: JSON.parse(
      '{"Accessibility Menu":"Menu di accessibilit\xC3 ","Reset settings":"Ripristina impostazioni","Close":"Chiudi","Content Adjustments":"Regolazioni del contenuto","Adjust Font Size":"Regola la dimensione del carattere","Highlight Title":"Evidenzia il titolo","Highlight Links":"Evidenzia i collegamenti","Readable Font":"Carattere leggibile","Color Adjustments":"Regolazioni del colore","Dark Contrast":"Contrasto scuro","Light Contrast":"Contrasto chiaro","High Contrast":"Alto contrasto","High Saturation":"Alta saturazione","Low Saturation":"Bassa saturazione","Monochrome":"Monocromatico","Tools":"Strumenti","Reading Guide":"Guida alla lettura","Stop Animations":"Arresta le animazioni","Big Cursor":"Cursore grande","Increase Font Size":"Aumenta la dimensione del carattere","Decrease Font Size":"Diminuisci la dimensione del carattere","Letter Spacing":"Spaziatura delle lettere","Line Height":"Altezza della linea","Font Weight":"Peso del carattere","Dyslexia Font":"Carattere per dislessia","Language":"Lingua","Open Accessibility Menu":"Apri il menu di accessibilit\xC3 "}'
    ),
    ja: JSON.parse(
      '{"Accessibility Menu":"\xE3\u201A\xA2\xE3\u201A\xAF\xE3\u201A\xBB\xE3\u201A\xB7\xE3\u0192\u201C\xE3\u0192\xAA\xE3\u0192\u2020\xE3\u201A\xA3\xE3\u0192\xA1\xE3\u0192\u2039\xE3\u0192\xA5\xE3\u0192\xBC","Reset settings":"\xE8\xA8\xAD\xE5\xAE\u0161\xE3\u201A\u2019\xE3\u0192\xAA\xE3\u201A\xBB\xE3\u0192\u0192\xE3\u0192\u02C6","Close":"\xE9\u2013\u2030\xE3\x81\u02DC\xE3\u201A\u2039","Content Adjustments":"\xE3\u201A\xB3\xE3\u0192\xB3\xE3\u0192\u2020\xE3\u0192\xB3\xE3\u0192\u201E\xE8\xAA\xBF\xE6\u2022\xB4","Adjust Font Size":"\xE3\u0192\u2022\xE3\u201A\xA9\xE3\u0192\xB3\xE3\u0192\u02C6\xE3\u201A\xB5\xE3\u201A\xA4\xE3\u201A\xBA\xE3\u201A\u2019\xE8\xAA\xBF\xE6\u2022\xB4","Highlight Title":"\xE3\u201A\xBF\xE3\u201A\xA4\xE3\u0192\u02C6\xE3\u0192\xAB\xE3\u201A\u2019\xE5\xBC\xB7\xE8\xAA\xBF\xE8\xA1\xA8\xE7\xA4\xBA","Highlight Links":"\xE3\u0192\xAA\xE3\u0192\xB3\xE3\u201A\xAF\xE3\u201A\u2019\xE5\xBC\xB7\xE8\xAA\xBF\xE8\xA1\xA8\xE7\xA4\xBA","Readable Font":"\xE8\xAA\xAD\xE3\x81\xBF\xE3\u201A\u201E\xE3\x81\u2122\xE3\x81\u201E\xE3\u0192\u2022\xE3\u201A\xA9\xE3\u0192\xB3\xE3\u0192\u02C6","Color Adjustments":"\xE8\u2030\xB2\xE3\x81\xAE\xE8\xAA\xBF\xE6\u2022\xB4","Dark Contrast":"\xE3\u0192\u20AC\xE3\u0192\xBC\xE3\u201A\xAF\xE3\u201A\xB3\xE3\u0192\xB3\xE3\u0192\u02C6\xE3\u0192\xA9\xE3\u201A\xB9\xE3\u0192\u02C6","Light Contrast":"\xE3\u0192\xA9\xE3\u201A\xA4\xE3\u0192\u02C6\xE3\u201A\xB3\xE3\u0192\xB3\xE3\u0192\u02C6\xE3\u0192\xA9\xE3\u201A\xB9\xE3\u0192\u02C6","High Contrast":"\xE9\xAB\u02DC\xE3\x81\u201E\xE3\u201A\xB3\xE3\u0192\xB3\xE3\u0192\u02C6\xE3\u0192\xA9\xE3\u201A\xB9\xE3\u0192\u02C6","High Saturation":"\xE5\xBD\xA9\xE5\xBA\xA6\xE3\x81\u0152\xE9\xAB\u02DC\xE3\x81\u201E","Low Saturation":"\xE5\xBD\xA9\xE5\xBA\xA6\xE3\x81\u0152\xE4\xBD\u017D\xE3\x81\u201E","Monochrome":"\xE3\u0192\xA2\xE3\u0192\u017D\xE3\u201A\xAF\xE3\u0192\xAD\xE3\u0192\xBC\xE3\u0192 ","Tools":"\xE3\u0192\u201E\xE3\u0192\xBC\xE3\u0192\xAB","Reading Guide":"\xE8\xAA\xAD\xE3\x81\xBF\xE4\xB8\u0160\xE3\x81\u2019\xE3\u201A\xAC\xE3\u201A\xA4\xE3\u0192\u2030","Stop Animations":"\xE3\u201A\xA2\xE3\u0192\u2039\xE3\u0192\xA1\xE3\u0192\xBC\xE3\u201A\xB7\xE3\u0192\xA7\xE3\u0192\xB3\xE3\u201A\u2019\xE5\x81\u0153\xE6\xAD\xA2","Big Cursor":"\xE5\xA4\xA7\xE3\x81\x8D\xE3\x81\xAA\xE3\u201A\xAB\xE3\u0192\xBC\xE3\u201A\xBD\xE3\u0192\xAB","Increase Font Size":"\xE3\u0192\u2022\xE3\u201A\xA9\xE3\u0192\xB3\xE3\u0192\u02C6\xE3\u201A\xB5\xE3\u201A\xA4\xE3\u201A\xBA\xE3\u201A\u2019\xE5\xA4\xA7\xE3\x81\x8D\xE3\x81\x8F\xE3\x81\u2122\xE3\u201A\u2039","Decrease Font Size":"\xE3\u0192\u2022\xE3\u201A\xA9\xE3\u0192\xB3\xE3\u0192\u02C6\xE3\u201A\xB5\xE3\u201A\xA4\xE3\u201A\xBA\xE3\u201A\u2019\xE5\xB0\x8F\xE3\x81\u2022\xE3\x81\x8F\xE3\x81\u2122\xE3\u201A\u2039","Letter Spacing":"\xE6\u2013\u2021\xE5\xAD\u2014\xE9\u2013\u201C\xE9\u0161\u201D","Line Height":"\xE8\xA1\u0152\xE3\x81\xAE\xE9\xAB\u02DC\xE3\x81\u2022","Font Weight":"\xE3\u0192\u2022\xE3\u201A\xA9\xE3\u0192\xB3\xE3\u0192\u02C6\xE3\x81\xAE\xE5\xA4\xAA\xE3\x81\u2022","Dyslexia Font":"\xE3\u0192\u2021\xE3\u201A\xA3\xE3\u201A\xB9\xE3\u0192\xAC\xE3\u201A\xAF\xE3\u201A\xB7\xE3\u201A\xA2\xE7\u201D\xA8\xE3\u0192\u2022\xE3\u201A\xA9\xE3\u0192\xB3\xE3\u0192\u02C6","Language":"\xE8\xA8\u20AC\xE8\xAA\u017E","Open Accessibility Menu":"\xE3\u201A\xA2\xE3\u201A\xAF\xE3\u201A\xBB\xE3\u201A\xB7\xE3\u0192\u201C\xE3\u0192\xAA\xE3\u0192\u2020\xE3\u201A\xA3\xE3\u0192\xA1\xE3\u0192\u2039\xE3\u0192\xA5\xE3\u0192\xBC\xE3\u201A\u2019\xE9\u2013\u2039\xE3\x81\x8F"}'
    ),
    ka: JSON.parse(
      '{"Accessibility Menu":"\xE1\u0192\x90\xE1\u0192\u201C\xE1\u0192\x90\xE1\u0192\u017E\xE1\u0192\xA2\xE1\u0192\u02DC\xE1\u0192 \xE1\u0192\u201D\xE1\u0192\u2018\xE1\u0192\xA3\xE1\u0192\u0161\xE1\u0192\u02DC \xE1\u0192\u203A\xE1\u0192\u201D\xE1\u0192\u0153\xE1\u0192\u02DC\xE1\u0192\xA3","Reset settings":"\xE1\u0192\u017E\xE1\u0192\x90\xE1\u0192 \xE1\u0192\x90\xE1\u0192\u203A\xE1\u0192\u201D\xE1\u0192\xA2\xE1\u0192 \xE1\u0192\u201D\xE1\u0192\u2018\xE1\u0192\u02DC\xE1\u0192\xA1 \xE1\u0192\u201C\xE1\u0192\x90\xE1\u0192\u2018\xE1\u0192 \xE1\u0192\xA3\xE1\u0192\u0153\xE1\u0192\u201D\xE1\u0192\u2018\xE1\u0192\x90","Close":"\xE1\u0192\u201C\xE1\u0192\x90\xE1\u0192\xAE\xE1\u0192\xA3\xE1\u0192 \xE1\u0192\u2022\xE1\u0192\x90","Content Adjustments":"\xE1\u0192\xA8\xE1\u0192\u02DC\xE1\u0192\u2019\xE1\u0192\u2014\xE1\u0192\x90\xE1\u0192\u2022\xE1\u0192\xA1\xE1\u0192\u02DC\xE1\u0192\xA1 \xE1\u0192\u203A\xE1\u0192\x9D\xE1\u0192 \xE1\u0192\u2019\xE1\u0192\u201D\xE1\u0192\u2018\xE1\u0192\x90","Adjust Font Size":"\xE1\u0192\xA4\xE1\u0192\x9D\xE1\u0192\u0153\xE1\u0192\xA2\xE1\u0192\u02DC\xE1\u0192\xA1 \xE1\u0192\u2013\xE1\u0192\x9D\xE1\u0192\u203A\xE1\u0192\u02DC\xE1\u0192\xA1 \xE1\u0192\u203A\xE1\u0192\x9D\xE1\u0192 \xE1\u0192\u2019\xE1\u0192\u201D\xE1\u0192\u2018\xE1\u0192\x90","Highlight Title":"\xE1\u0192\xA1\xE1\u0192\x90\xE1\u0192\u2014\xE1\u0192\x90\xE1\u0192\xA3\xE1\u0192 \xE1\u0192\u201D\xE1\u0192\u2018\xE1\u0192\u02DC\xE1\u0192\xA1 \xE1\u0192\u2019\xE1\u0192\x90\xE1\u0192\u203A\xE1\u0192\x9D\xE1\u0192\xA7\xE1\u0192\x9D\xE1\u0192\xA4\xE1\u0192\x90","Highlight Links":"\xE1\u0192\u2018\xE1\u0192\u203A\xE1\u0192\xA3\xE1\u0192\u0161\xE1\u0192\u201D\xE1\u0192\u2018\xE1\u0192\u02DC\xE1\u0192\xA1 \xE1\u0192\u2019\xE1\u0192\x90\xE1\u0192\u203A\xE1\u0192\x9D\xE1\u0192\xA7\xE1\u0192\x9D\xE1\u0192\xA4\xE1\u0192\x90","Readable Font":"\xE1\u0192\xAC\xE1\u0192\x90\xE1\u0192\u2122\xE1\u0192\u02DC\xE1\u0192\u2014\xE1\u0192\xAE\xE1\u0192\u2022\xE1\u0192\x90\xE1\u0192\u201C\xE1\u0192\u02DC \xE1\u0192\xA2\xE1\u0192\u201D\xE1\u0192\xA5\xE1\u0192\xA1\xE1\u0192\xA2\xE1\u0192\u201D\xE1\u0192\u2018\xE1\u0192\u02DC","Color Adjustments":"\xE1\u0192\xA4\xE1\u0192\u201D\xE1\u0192 \xE1\u0192\u201D\xE1\u0192\u2018\xE1\u0192\u02DC\xE1\u0192\xA1 \xE1\u0192\u203A\xE1\u0192\x9D\xE1\u0192 \xE1\u0192\u2019\xE1\u0192\u201D\xE1\u0192\u2018\xE1\u0192\x90","Dark Contrast":"\xE1\u0192\u2018\xE1\u0192\u0153\xE1\u0192\u201D\xE1\u0192\u0161\xE1\u0192\u02DC \xE1\u0192\u201D\xE1\u0192\u0161\xE1\u0192\xA4\xE1\u0192\u201D\xE1\u0192 \xE1\u0192\u02DC","Light Contrast":"\xE1\u0192\u0153\xE1\u0192\x90\xE1\u0192\u2014\xE1\u0192\u201D\xE1\u0192\u0161\xE1\u0192\u02DC \xE1\u0192\u201D\xE1\u0192\u0161\xE1\u0192\xA4\xE1\u0192\u201D\xE1\u0192 \xE1\u0192\u02DC","High Contrast":"\xE1\u0192\u203A\xE1\u0192\x90\xE1\u0192\xA6\xE1\u0192\x90\xE1\u0192\u0161\xE1\u0192\u02DC \xE1\u0192\u201D\xE1\u0192\u0161\xE1\u0192\xA4\xE1\u0192\u201D\xE1\u0192 \xE1\u0192\u02DC","High Saturation":"\xE1\u0192\u203A\xE1\u0192\x90\xE1\u0192\xA6\xE1\u0192\x90\xE1\u0192\u0161\xE1\u0192\u02DC \xE1\u0192\u2019\xE1\u0192\x90\xE1\u0192\xAF\xE1\u0192\u201D\xE1\u0192 \xE1\u0192\u201D\xE1\u0192\u2018\xE1\u0192\x90","Low Saturation":"\xE1\u0192\u201C\xE1\u0192\x90\xE1\u0192\u2018\xE1\u0192\x90\xE1\u0192\u0161\xE1\u0192\u02DC \xE1\u0192\u2019\xE1\u0192\x90\xE1\u0192\xAF\xE1\u0192\u201D\xE1\u0192 \xE1\u0192\u201D\xE1\u0192\u2018\xE1\u0192\x90","Monochrome":"\xE1\u0192\u201D\xE1\u0192 \xE1\u0192\u2014\xE1\u0192\xA4\xE1\u0192\u201D\xE1\u0192 \xE1\u0192\x9D\xE1\u0192\u2022\xE1\u0192\x90\xE1\u0192\u0153\xE1\u0192\u02DC \xE1\u0192\u2019\xE1\u0192\x90\xE1\u0192\u203A\xE1\u0192\x9D\xE1\u0192\xA1\xE1\u0192\x90\xE1\u0192\xAE\xE1\u0192\xA3\xE1\u0192\u0161\xE1\u0192\u201D\xE1\u0192\u2018\xE1\u0192\x90","Tools":"\xE1\u0192\xAE\xE1\u0192\u201D\xE1\u0192\u0161\xE1\u0192\xA1\xE1\u0192\x90\xE1\u0192\xAC\xE1\u0192\xA7\xE1\u0192\x9D\xE1\u0192\u201D\xE1\u0192\u2018\xE1\u0192\u02DC","Reading Guide":"\xE1\u0192\u2122\xE1\u0192\u02DC\xE1\u0192\u2014\xE1\u0192\xAE\xE1\u0192\u2022\xE1\u0192\u02DC\xE1\u0192\xA1 \xE1\u0192\u2019\xE1\u0192\x90\xE1\u0192\u203A\xE1\u0192\xA7\xE1\u0192\x9D\xE1\u0192\u0161\xE1\u0192\u02DC \xE1\u0192\u2013\xE1\u0192\x9D\xE1\u0192\u0161\xE1\u0192\u02DC","Stop Animations":"\xE1\u0192\x90\xE1\u0192\u0153\xE1\u0192\u02DC\xE1\u0192\u203A\xE1\u0192\x90\xE1\u0192\xAA\xE1\u0192\u02DC\xE1\u0192\u201D\xE1\u0192\u2018\xE1\u0192\u02DC\xE1\u0192\xA1 \xE1\u0192\u2019\xE1\u0192\x90\xE1\u0192\xA9\xE1\u0192\u201D\xE1\u0192 \xE1\u0192\u201D\xE1\u0192\u2018\xE1\u0192\x90","Big Cursor":"\xE1\u0192\u201C\xE1\u0192\u02DC\xE1\u0192\u201C\xE1\u0192\u02DC \xE1\u0192\u2122\xE1\u0192\xA3\xE1\u0192 \xE1\u0192\xA1\xE1\u0192\x9D\xE1\u0192 \xE1\u0192\u02DC","Increase Font Size":"\xE1\u0192\xA4\xE1\u0192\x9D\xE1\u0192\u0153\xE1\u0192\xA2\xE1\u0192\u02DC\xE1\u0192\xA1 \xE1\u0192\u2013\xE1\u0192\x9D\xE1\u0192\u203A\xE1\u0192\u02DC\xE1\u0192\xA1 \xE1\u0192\u2019\xE1\u0192\x90\xE1\u0192\u2013\xE1\u0192 \xE1\u0192\u201C\xE1\u0192\x90","Decrease Font Size":"\xE1\u0192\xA4\xE1\u0192\x9D\xE1\u0192\u0153\xE1\u0192\xA2\xE1\u0192\u02DC\xE1\u0192\xA1 \xE1\u0192\u2013\xE1\u0192\x9D\xE1\u0192\u203A\xE1\u0192\u02DC\xE1\u0192\xA1 \xE1\u0192\xA8\xE1\u0192\u201D\xE1\u0192\u203A\xE1\u0192\xAA\xE1\u0192\u02DC\xE1\u0192 \xE1\u0192\u201D\xE1\u0192\u2018\xE1\u0192\x90","Letter Spacing":"\xE1\u0192\x90\xE1\u0192\xA1\xE1\u0192\x9D\xE1\u0192\u201D\xE1\u0192\u2018\xE1\u0192\xA1 \xE1\u0192\xA8\xE1\u0192\x9D\xE1\u0192 \xE1\u0192\u02DC\xE1\u0192\xA1 \xE1\u0192\u201C\xE1\u0192\x90\xE1\u0192\xA8\xE1\u0192\x9D\xE1\u0192 \xE1\u0192\u201D\xE1\u0192\u2018\xE1\u0192\x90","Line Height":"\xE1\u0192\xAE\xE1\u0192\x90\xE1\u0192\u2013\xE1\u0192\u02DC\xE1\u0192\xA1 \xE1\u0192\xA1\xE1\u0192\u02DC\xE1\u0192\u203A\xE1\u0192\x90\xE1\u0192\xA6\xE1\u0192\u0161\xE1\u0192\u201D","Font Weight":"\xE1\u0192\xA4\xE1\u0192\x9D\xE1\u0192\u0153\xE1\u0192\xA2\xE1\u0192\u02DC\xE1\u0192\xA1 \xE1\u0192\xAC\xE1\u0192\x9D\xE1\u0192\u0153\xE1\u0192\x90","Dyslexia Font":"\xE1\u0192\u201C\xE1\u0192\u02DC\xE1\u0192\xA1\xE1\u0192\u0161\xE1\u0192\u201D\xE1\u0192\xA5\xE1\u0192\xA1\xE1\u0192\u02DC\xE1\u0192\xA3\xE1\u0192 \xE1\u0192\u02DC \xE1\u0192\xA4\xE1\u0192\x9D\xE1\u0192\u0153\xE1\u0192\xA2\xE1\u0192\u02DC","Language":"\xE1\u0192\u201D\xE1\u0192\u0153\xE1\u0192\x90","Open Accessibility Menu":"\xE1\u0192\u2019\xE1\u0192\x90\xE1\u0192\xAE\xE1\u0192\xA1\xE1\u0192\u201D\xE1\u0192\u0153\xE1\u0192\u02DC \xE1\u0192\x90\xE1\u0192\u201C\xE1\u0192\x90\xE1\u0192\u017E\xE1\u0192\xA2\xE1\u0192\u02DC\xE1\u0192 \xE1\u0192\u201D\xE1\u0192\u2018\xE1\u0192\xA3\xE1\u0192\u0161\xE1\u0192\u02DC \xE1\u0192\u203A\xE1\u0192\u201D\xE1\u0192\u0153\xE1\u0192\u02DC\xE1\u0192\xA3"}'
    ),
    ko: JSON.parse(
      '{"Accessibility Menu":"\xEC \u2018\xEA\xB7\xBC\xEC\u201E\xB1 \xEB\xA9\u201D\xEB\u2030\xB4","Reset settings":"\xEC\u201E\xA4\xEC \u2022 \xEC\xB4\u02C6\xEA\xB8\xB0\xED\u2122\u201D","Close":"\xEB\u2039\xAB\xEA\xB8\xB0","Content Adjustments":"\xEC\xBB\xA8\xED\u2026\x90\xEC\xB8  \xEC\xA1\xB0\xEC \u2022","Adjust Font Size":"\xEA\xB8\u20AC\xEA\xBC\xB4 \xED\x81\xAC\xEA\xB8\xB0 \xEC\xA1\xB0\xEC \u2022","Highlight Title":"\xEC \u0153\xEB\xAA\xA9 \xEA\xB0\u2022\xEC\xA1\xB0","Highlight Links":"\xEB\xA7\x81\xED\x81\xAC \xEA\xB0\u2022\xEC\xA1\xB0","Readable Font":"\xEC\x9D\xBD\xEA\xB8\xB0 \xEC\u2030\xAC\xEC\u0161\xB4 \xEA\xB8\u20AC\xEA\xBC\xB4","Color Adjustments":"\xEC\u0192\u2030\xEC\u0192\x81 \xEC\xA1\xB0\xEC \u2022","Dark Contrast":"\xEC\u2013\xB4\xEB\u2018\x90\xEC\u0161\xB4 \xEB\u0152\u20AC\xEB\xB9\u201E","Light Contrast":"\xEB\xB0\x9D\xEC\x9D\u20AC \xEB\u0152\u20AC\xEB\xB9\u201E","High Contrast":"\xEB\u2020\u2019\xEC\x9D\u20AC \xEB\u0152\u20AC\xEB\xB9\u201E","High Saturation":"\xEB\u2020\u2019\xEC\x9D\u20AC \xEC\xB1\u201E\xEB\x8F\u201E","Low Saturation":"\xEB\u201A\xAE\xEC\x9D\u20AC \xEC\xB1\u201E\xEB\x8F\u201E","Monochrome":"\xEB\u2039\xA8\xEC\u0192\u2030","Tools":"\xEB\x8F\u201E\xEA\xB5\xAC","Reading Guide":"\xEC\x9D\xBD\xEA\xB8\xB0 \xEA\xB0\u20AC\xEC\x9D\xB4\xEB\u201C\u0153","Stop Animations":"\xEC\u2022 \xEB\u2039\u02C6\xEB\xA9\u201D\xEC\x9D\xB4\xEC\u2026\u02DC \xEC\xA4\u2018\xEC\xA7\u20AC","Big Cursor":"\xED\x81\xB0 \xEC\xBB\xA4\xEC\u201E\u0153","Increase Font Size":"\xEA\xB8\u20AC\xEA\xBC\xB4 \xED\x81\xAC\xEA\xB8\xB0 \xEC\xA6\x9D\xEA\xB0\u20AC","Decrease Font Size":"\xEA\xB8\u20AC\xEA\xBC\xB4 \xED\x81\xAC\xEA\xB8\xB0 \xEA\xB0\x90\xEC\u2020\u0152","Letter Spacing":"\xEC\u017E\x90\xEA\xB0\u201E","Line Height":"\xEC\xA4\u201E \xEA\xB0\u201E\xEA\xB2\xA9","Font Weight":"\xEA\xB8\u20AC\xEA\xBC\xB4 \xEB\u2018\x90\xEA\xBB\u02DC","Dyslexia Font":"\xEB\u201A\u0153\xEB\x8F\u2026\xEC\xA6\x9D \xEA\xB8\u20AC\xEA\xBC\xB4","Language":"\xEC\u2013\xB8\xEC\u2013\xB4","Open Accessibility Menu":"\xEC \u2018\xEA\xB7\xBC\xEC\u201E\xB1 \xEB\xA9\u201D\xEB\u2030\xB4 \xEC\u2014\xB4\xEA\xB8\xB0"}'
    ),
    ms: JSON.parse(
      '{"Accessibility Menu":"Menu Aksesibiliti","Reset settings":"Tetapkan semula tetapan","Close":"Tutup","Content Adjustments":"Penyesuaian Kandungan","Adjust Font Size":"Laraskan Saiz Fon","Highlight Title":"Serlahkan Tajuk","Highlight Links":"Serlahkan Pautan","Readable Font":"Fon Mudah Baca","Color Adjustments":"Penyesuaian Warna","Dark Contrast":"Kontras Gelap","Light Contrast":"Kontras Terang","High Contrast":"Kontras Tinggi","High Saturation":"Saturasi Tinggi","Low Saturation":"Saturasi Rendah","Monochrome":"Monokrom","Tools":"Peralatan","Reading Guide":"Panduan Membaca","Stop Animations":"Hentikan Animasi","Big Cursor":"Kursor Besar","Increase Font Size":"Besarkan Saiz Fon","Decrease Font Size":"Kecilkan Saiz Fon","Letter Spacing":"Ruangan Huruf","Line Height":"Ketinggian Garis","Font Weight":"Ketebalan Fon","Dyslexia Font":"Fon Dyslexia","Language":"Bahasa","Open Accessibility Menu":"Buka menu kebolehcapaian"}'
    ),
    nl: JSON.parse(
      '{"Accessibility Menu":"Toegankelijkheidsmenu","Reset settings":"Instellingen resetten","Close":"Sluiten","Content Adjustments":"Inhoudsaanpassingen","Adjust Font Size":"Lettergrootte aanpassen","Highlight Title":"Titel markeren","Highlight Links":"Links markeren","Readable Font":"Leesbaar lettertype","Color Adjustments":"Kleur aanpassingen","Dark Contrast":"Donker contrast","Light Contrast":"Licht contrast","High Contrast":"Hoog contrast","High Saturation":"Hoge verzadiging","Low Saturation":"Lage verzadiging","Monochrome":"Monochroom","Tools":"Gereedschappen","Reading Guide":"Leesgids","Stop Animations":"Animaties stoppen","Big Cursor":"Grote cursor","Increase Font Size":"Lettergrootte vergroten","Decrease Font Size":"Lettergrootte verkleinen","Letter Spacing":"Letterafstand","Line Height":"Regelhoogte","Font Weight":"Letterdikte","Dyslexia Font":"Dyslexie lettertype","Language":"Taal","Open Accessibility Menu":"Toegankelijkheidsmenu openen"}'
    ),
    no: JSON.parse(
      '{"Accessibility Menu":"Tilgjengelighetsmeny","Reset settings":"Tilbakestill innstillinger","Close":"Lukk","Content Adjustments":"Innholdstilpasninger","Adjust Font Size":"Juster skriftst\xC3\xB8rrelse","Highlight Title":"Fremhev tittel","Highlight Links":"Fremhev lenker","Readable Font":"Lesbar skrifttype","Color Adjustments":"Fargejusteringer","Dark Contrast":"M\xC3\xB8rk kontrast","Light Contrast":"Lys kontrast","High Contrast":"H\xC3\xB8y kontrast","High Saturation":"H\xC3\xB8y metning","Low Saturation":"Lav metning","Monochrome":"Monokrom","Tools":"Verkt\xC3\xB8y","Reading Guide":"Leseguide","Stop Animations":"Stopp animasjoner","Big Cursor":"Stor peker","Increase Font Size":"\xC3\u02DCk skriftst\xC3\xB8rrelsen","Decrease Font Size":"Reduser skriftst\xC3\xB8rrelsen","Letter Spacing":"Bokstavavstand","Line Height":"Linjeh\xC3\xB8yde","Font Weight":"Skriftvekt","Dyslexia Font":"Dysleksisk skrifttype","Language":"Spr\xC3\xA5k","Open Accessibility Menu":"\xC3\u2026pne tilgjengelighetsmeny"}'
    ),
    fa: JSON.parse(
      '{"Accessibility Menu":"\xD9\u2026\xD9\u2020\xD9\u02C6\xDB\u0152 \xD8\xAF\xD8\xB3\xD8\xAA\xD8\xB1\xD8\xB3\xDB\u0152","Reset settings":"\xD8\xA8\xD8\xA7\xD8\xB2\xD9\u2020\xD8\xB4\xD8\xA7\xD9\u2020\xDB\u0152 \xD8\xAA\xD9\u2020\xD8\xB8\xDB\u0152\xD9\u2026\xD8\xA7\xD8\xAA","Close":"\xD8\xA8\xD8\xB3\xD8\xAA\xD9\u2020","Content Adjustments":"\xD8\xAA\xD9\u2020\xD8\xB8\xDB\u0152\xD9\u2026\xD8\xA7\xD8\xAA \xD9\u2026\xD8\xAD\xD8\xAA\xD9\u02C6\xD8\xA7","Adjust Font Size":"\xD8\xAA\xD9\u2020\xD8\xB8\xDB\u0152\xD9\u2026 \xD8\xA7\xD9\u2020\xD8\xAF\xD8\xA7\xD8\xB2\xD9\u2021 \xD9\x81\xD9\u02C6\xD9\u2020\xD8\xAA","Highlight Title":"\xD8\xA8\xD8\xB1\xD8\xAC\xD8\xB3\xD8\xAA\xD9\u2021 \xDA\xA9\xD8\xB1\xD8\xAF\xD9\u2020 \xD8\xB9\xD9\u2020\xD9\u02C6\xD8\xA7\xD9\u2020","Highlight Links":"\xD8\xA8\xD8\xB1\xD8\xAC\xD8\xB3\xD8\xAA\xD9\u2021 \xDA\xA9\xD8\xB1\xD8\xAF\xD9\u2020 \xD9\u201E\xDB\u0152\xD9\u2020\xDA\xA9\xE2\u20AC\u0152\xD9\u2021\xD8\xA7","Readable Font":"\xD9\x81\xD9\u02C6\xD9\u2020\xD8\xAA \xD8\xAE\xD9\u02C6\xD8\xA7\xD9\u2020\xD8\xA7","Color Adjustments":"\xD8\xAA\xD9\u2020\xD8\xB8\xDB\u0152\xD9\u2026\xD8\xA7\xD8\xAA \xD8\xB1\xD9\u2020\xDA\xAF","Dark Contrast":"\xDA\xA9\xD9\u2020\xD8\xAA\xD8\xB1\xD8\xA7\xD8\xB3\xD8\xAA \xD8\xAA\xD8\xA7\xD8\xB1\xDB\u0152\xDA\xA9","Light Contrast":"\xDA\xA9\xD9\u2020\xD8\xAA\xD8\xB1\xD8\xA7\xD8\xB3\xD8\xAA \xD8\xB1\xD9\u02C6\xD8\xB4\xD9\u2020","High Contrast":"\xDA\xA9\xD9\u2020\xD8\xAA\xD8\xB1\xD8\xA7\xD8\xB3\xD8\xAA \xD8\xA8\xD8\xA7\xD9\u201E\xD8\xA7","High Saturation":"\xD8\xA7\xD8\xB4\xD8\xA8\xD8\xA7\xD8\xB9 \xD8\xA8\xD8\xA7\xD9\u201E\xD8\xA7","Low Saturation":"\xD8\xA7\xD8\xB4\xD8\xA8\xD8\xA7\xD8\xB9 \xD9\xBE\xD8\xA7\xDB\u0152\xDB\u0152\xD9\u2020","Monochrome":"\xD8\xAA\xDA\xA9\xE2\u20AC\u0152\xD8\xB1\xD9\u2020\xDA\xAF","Tools":"\xD8\xA7\xD8\xA8\xD8\xB2\xD8\xA7\xD8\xB1\xD9\u2021\xD8\xA7","Reading Guide":"\xD8\xB1\xD8\xA7\xD9\u2021\xD9\u2020\xD9\u2026\xD8\xA7\xDB\u0152 \xD8\xAE\xD9\u02C6\xD8\xA7\xD9\u2020\xD8\xAF\xD9\u2020","Stop Animations":"\xD8\xAA\xD9\u02C6\xD9\u201A\xD9\x81 \xD8\xA7\xD9\u2020\xDB\u0152\xD9\u2026\xDB\u0152\xD8\xB4\xD9\u2020\xE2\u20AC\u0152\xD9\u2021\xD8\xA7","Big Cursor":"\xD9\u2026\xD8\xA4\xD8\xB4\xD8\xB1 \xD8\xA8\xD8\xB2\xD8\xB1\xDA\xAF","Increase Font Size":"\xD8\xA7\xD9\x81\xD8\xB2\xD8\xA7\xDB\u0152\xD8\xB4 \xD8\xA7\xD9\u2020\xD8\xAF\xD8\xA7\xD8\xB2\xD9\u2021 \xD9\x81\xD9\u02C6\xD9\u2020\xD8\xAA","Decrease Font Size":"\xDA\xA9\xD8\xA7\xD9\u2021\xD8\xB4 \xD8\xA7\xD9\u2020\xD8\xAF\xD8\xA7\xD8\xB2\xD9\u2021 \xD9\x81\xD9\u02C6\xD9\u2020\xD8\xAA","Letter Spacing":"\xD9\x81\xD8\xA7\xD8\xB5\xD9\u201E\xD9\u2021 \xD8\xA8\xDB\u0152\xD9\u2020 \xD8\xAD\xD8\xB1\xD9\u02C6\xD9\x81","Line Height":"\xD8\xA7\xD8\xB1\xD8\xAA\xD9\x81\xD8\xA7\xD8\xB9 \xD8\xAE\xD8\xB7","Font Weight":"\xD9\u02C6\xD8\xB2\xD9\u2020 \xD9\x81\xD9\u02C6\xD9\u2020\xD8\xAA","Dyslexia Font":"\xD9\x81\xD9\u02C6\xD9\u2020\xD8\xAA \xD8\xAF\xDB\u0152\xD8\xB3\xD9\u201E\xDA\xA9\xD8\xB3\xDB\u0152\xD8\xA7","Language":"\xD8\xB2\xD8\xA8\xD8\xA7\xD9\u2020","Open Accessibility Menu":"\xD8\xA8\xD8\xA7\xD8\xB2\xDA\xA9\xD8\xB1\xD8\xAF\xD9\u2020 \xD9\u2026\xD9\u2020\xD9\u02C6\xDB\u0152 \xD8\xAF\xD8\xB3\xD8\xAA\xD8\xB1\xD8\xB3\xDB\u0152"}'
    ),
    pl: JSON.parse(
      '{"Accessibility Menu":"Menu dost\xC4\u2122pno\xC5\u203Aci","Reset settings":"Reset ustawie\xC5\u201E","Close":"Zamknij","Content Adjustments":"Dostosowanie zawarto\xC5\u203Aci","Adjust Font Size":"Dostosuj rozmiar czcionki","Highlight Title":"Pod\xC5\u203Awietl tytu\xC5\u201Ay","Highlight Links":"Pod\xC5\u203Awietl linki","Readable Font":"Czytelna czcionka","Color Adjustments":"Dostosowanie kolorów","Dark Contrast":"Ciemny kontrast","Light Contrast":"Jasny kontrast","High Contrast":"Wysoki kontrast","High Saturation":"Wysoka saturacja","Low Saturation":"Niska saturacja","Monochrome":"Monochromatyczno\xC5\u203A\xC4\u2021","Tools":"Narz\xC4\u2122dzia","Reading Guide":"Pomocnik czytania","Stop Animations":"Wstrzymaj animacje","Big Cursor":"Du\xC5\xBCy kursor","Increase Font Size":"Zwi\xC4\u2122ksz rozmiar czcionki","Decrease Font Size":"Zmniejsz rozmiar czcionki","Letter Spacing":"Odst\xC4\u2122py mi\xC4\u2122dzy literami","Line Height":"Wysoko\xC5\u203A\xC4\u2021 wierszy","Font Weight":"Pogrubiona czcionka","Dyslexia Font":"Czcionka dla dyslektyków","Language":"J\xC4\u2122zyk","Open Accessibility Menu":"Otwórz menu dost\xC4\u2122pno\xC5\u203Aci"}'
    ),
    pt: JSON.parse(
      '{"Accessibility Menu":"Menu de Acessibilidade","Reset settings":"Redefinir configura\xC3\xA7\xC3\xB5es","Close":"Fechar","Content Adjustments":"Ajustes de Conteúdo","Adjust Font Size":"Ajustar Tamanho da Fonte","Highlight Title":"Destacar Título","Highlight Links":"Destacar Links","Readable Font":"Fonte Legível","Color Adjustments":"Ajustes de Cor","Dark Contrast":"Contraste Escuro","Light Contrast":"Contraste Claro","High Contrast":"Alto Contraste","High Saturation":"Satura\xC3\xA7\xC3\xA3o Alta","Low Saturation":"Satura\xC3\xA7\xC3\xA3o Baixa","Monochrome":"Monocrom\xC3\xA1tico","Tools":"Ferramentas","Reading Guide":"Guia de Leitura","Stop Animations":"Parar Anima\xC3\xA7\xC3\xB5es","Big Cursor":"Cursor Grande","Increase Font Size":"Aumentar Tamanho da Fonte","Decrease Font Size":"Diminuir Tamanho da Fonte","Letter Spacing":"Espa\xC3\xA7amento entre Letras","Line Height":"Altura da Linha","Font Weight":"Espessura da Fonte","Dyslexia Font":"Fonte para Dislexia","Language":"Idioma","Open Accessibility Menu":"Abrir menu de acessibilidade"}'
    ),
    ro: JSON.parse(
      '{"Accessibility Menu":"Meniu de accesibilitate","Reset settings":"Reseteaz\xC4\u0192 set\xC4\u0192rile","Close":"\xC3\u017Dnchide","Content Adjustments":"Ajust\xC4\u0192ri con\xC8\u203Ainut","Adjust Font Size":"Ajusteaz\xC4\u0192 dimensiunea fontului","Highlight Title":"Eviden\xC8\u203Aiaz\xC4\u0192 titlul","Highlight Links":"Eviden\xC8\u203Aiaz\xC4\u0192 leg\xC4\u0192turile","Readable Font":"Font lizibil","Color Adjustments":"Ajust\xC4\u0192ri de culoare","Dark Contrast":"Contrast \xC3\xAEntunecat","Light Contrast":"Contrast luminos","High Contrast":"Contrast ridicat","High Saturation":"Satura\xC8\u203Aie ridicat\xC4\u0192","Low Saturation":"Satura\xC8\u203Aie redus\xC4\u0192","Monochrome":"Monocrom","Tools":"Instrumente","Reading Guide":"Ghid de lectur\xC4\u0192","Stop Animations":"Opri\xC8\u203Ai anima\xC8\u203Aiile","Big Cursor":"Cursor mare","Increase Font Size":"M\xC4\u0192re\xC8\u2122te dimensiunea fontului","Decrease Font Size":"Mic\xC8\u2122oreaz\xC4\u0192 dimensiunea fontului","Letter Spacing":"Spa\xC8\u203Aierea literelor","Line Height":"\xC3\u017Dn\xC4\u0192l\xC8\u203Aimea liniei","Font Weight":"Grosimea fontului","Dyslexia Font":"Font pentru dislexie","Language":"Limb\xC4\u0192","Open Accessibility Menu":"Deschide\xC8\u203Ai meniul de accesibilitate"}'
    ),
    ru: JSON.parse(
      '{"Accessibility Menu":"\xD0\u0153\xD0\xB5\xD0\xBD\xD1\u017D \xD1\x81\xD0\xBF\xD0\xB5\xD1\u2020\xD0\xB8\xD0\xB0\xD0\xBB\xD1\u0152\xD0\xBD\xD1\u2039\xD1\u2026 \xD0\xB2\xD0\xBE\xD0\xB7\xD0\xBC\xD0\xBE\xD0\xB6\xD0\xBD\xD0\xBE\xD1\x81\xD1\u201A\xD0\xB5\xD0\xB9","Reset settings":"\xD0\xA1\xD0\xB1\xD1\u20AC\xD0\xBE\xD1\x81 \xD0\xBD\xD0\xB0\xD1\x81\xD1\u201A\xD1\u20AC\xD0\xBE\xD0\xB5\xD0\xBA","Close":"\xD0\u2014\xD0\xB0\xD0\xBA\xD1\u20AC\xD1\u2039\xD1\u201A\xD1\u0152","Content Adjustments":"\xD0\u0161\xD0\xBE\xD1\u20AC\xD1\u20AC\xD0\xB5\xD0\xBA\xD1\u201A\xD0\xB8\xD1\u20AC\xD0\xBE\xD0\xB2\xD0\xBA\xD0\xB0 \xD0\xBA\xD0\xBE\xD0\xBD\xD1\u201A\xD0\xB5\xD0\xBD\xD1\u201A\xD0\xB0","Adjust Font Size":"\xD0\x9D\xD0\xB0\xD1\x81\xD1\u201A\xD1\u20AC\xD0\xBE\xD0\xB9\xD0\xBA\xD0\xB0 \xD1\u20AC\xD0\xB0\xD0\xB7\xD0\xBC\xD0\xB5\xD1\u20AC\xD0\xB0 \xD1\u02C6\xD1\u20AC\xD0\xB8\xD1\u201E\xD1\u201A\xD0\xB0","Highlight Title":"\xD0\u2019\xD1\u2039\xD0\xB4\xD0\xB5\xD0\xBB\xD0\xB8\xD1\u201A\xD1\u0152 \xD0\xB7\xD0\xB0\xD0\xB3\xD0\xBE\xD0\xBB\xD0\xBE\xD0\xB2\xD0\xBA\xD0\xB8","Highlight Links":"\xD0\u2019\xD1\u2039\xD0\xB4\xD0\xB5\xD0\xBB\xD0\xB8\xD1\u201A\xD1\u0152 \xD1\x81\xD1\x81\xD1\u2039\xD0\xBB\xD0\xBA\xD0\xB8","Readable Font":"\xD0\xA7\xD0\xB8\xD1\u201A\xD0\xB0\xD0\xB5\xD0\xBC\xD1\u2039\xD0\xB9 \xD1\u02C6\xD1\u20AC\xD0\xB8\xD1\u201E\xD1\u201A","Color Adjustments":"\xD0\u0161\xD0\xBE\xD1\u20AC\xD1\u20AC\xD0\xB5\xD0\xBA\xD1\u2020\xD0\xB8\xD1\x8F \xD1\u2020\xD0\xB2\xD0\xB5\xD1\u201A\xD0\xB0","Dark Contrast":"\xD0\xA2\xD0\xB5\xD0\xBC\xD0\xBD\xD1\u2039\xD0\xB9 \xD0\xBA\xD0\xBE\xD0\xBD\xD1\u201A\xD1\u20AC\xD0\xB0\xD1\x81\xD1\u201A","Light Contrast":"\xD0\xA1\xD0\xB2\xD0\xB5\xD1\u201A\xD0\xBB\xD1\u2039\xD0\xB9 \xD0\xBA\xD0\xBE\xD0\xBD\xD1\u201A\xD1\u20AC\xD0\xB0\xD1\x81\xD1\u201A","High Contrast":"\xD0\u2019\xD1\u2039\xD1\x81\xD0\xBE\xD0\xBA\xD0\xB8\xD0\xB9 \xD0\xBA\xD0\xBE\xD0\xBD\xD1\u201A\xD1\u20AC\xD0\xB0\xD1\x81\xD1\u201A","High Saturation":"\xD0\u2019\xD1\u2039\xD1\x81\xD0\xBE\xD0\xBA\xD0\xB0\xD1\x8F \xD0\xBD\xD0\xB0\xD1\x81\xD1\u2039\xD1\u2030\xD0\xB5\xD0\xBD\xD0\xBD\xD0\xBE\xD1\x81\xD1\u201A\xD1\u0152","Low Saturation":"\xD0\x9D\xD0\xB8\xD0\xB7\xD0\xBA\xD0\xB0\xD1\x8F \xD0\xBD\xD0\xB0\xD1\x81\xD1\u2039\xD1\u2030\xD0\xB5\xD0\xBD\xD0\xBD\xD0\xBE\xD1\x81\xD1\u201A\xD1\u0152","Monochrome":"\xD0\u0153\xD0\xBE\xD0\xBD\xD0\xBE\xD1\u2026\xD1\u20AC\xD0\xBE\xD0\xBC\xD0\xBD\xD1\u2039\xD0\xB9 \xD1\u2020\xD0\xB2\xD0\xB5\xD1\u201A","Tools":"\xD0\u02DC\xD0\xBD\xD1\x81\xD1\u201A\xD1\u20AC\xD1\u0192\xD0\xBC\xD0\xB5\xD0\xBD\xD1\u201A\xD1\u2039","Reading Guide":"\xD0 \xD1\u0192\xD0\xBA\xD0\xBE\xD0\xB2\xD0\xBE\xD0\xB4\xD1\x81\xD1\u201A\xD0\xB2\xD0\xBE \xD0\xBF\xD0\xBE \xD1\u2021\xD1\u201A\xD0\xB5\xD0\xBD\xD0\xB8\xD1\u017D","Stop Animations":"\xD0\u017E\xD1\x81\xD1\u201A\xD0\xB0\xD0\xBD\xD0\xBE\xD0\xB2\xD0\xB8\xD1\u201A\xD1\u0152 \xD0\xB0\xD0\xBD\xD0\xB8\xD0\xBC\xD0\xB0\xD1\u2020\xD0\xB8\xD1\u017D","Big Cursor":"\xD0\u2018\xD0\xBE\xD0\xBB\xD1\u0152\xD1\u02C6\xD0\xBE\xD0\xB9 \xD0\xBA\xD1\u0192\xD1\u20AC\xD1\x81\xD0\xBE\xD1\u20AC","Increase Font Size":"\xD0\xA3\xD0\xB2\xD0\xB5\xD0\xBB\xD0\xB8\xD1\u2021\xD0\xB8\xD1\u201A\xD1\u0152 \xD1\u20AC\xD0\xB0\xD0\xB7\xD0\xBC\xD0\xB5\xD1\u20AC \xD1\u02C6\xD1\u20AC\xD0\xB8\xD1\u201E\xD1\u201A\xD0\xB0","Decrease Font Size":"\xD0\xA3\xD0\xBC\xD0\xB5\xD0\xBD\xD1\u0152\xD1\u02C6\xD0\xB8\xD1\u201A\xD1\u0152 \xD1\u20AC\xD0\xB0\xD0\xB7\xD0\xBC\xD0\xB5\xD1\u20AC \xD1\u02C6\xD1\u20AC\xD0\xB8\xD1\u201E\xD1\u201A\xD0\xB0","Letter Spacing":"\xD0\u0153\xD0\xB5\xD0\xB6\xD0\xB1\xD1\u0192\xD0\xBA\xD0\xB2\xD0\xB5\xD0\xBD\xD0\xBD\xD0\xBE\xD0\xB5 \xD1\u20AC\xD0\xB0\xD1\x81\xD1\x81\xD1\u201A\xD0\xBE\xD1\x8F\xD0\xBD\xD0\xB8\xD0\xB5","Line Height":"\xD0\u2019\xD1\u2039\xD1\x81\xD0\xBE\xD1\u201A\xD0\xB0 \xD0\xBB\xD0\xB8\xD0\xBD\xD0\xB8\xD0\xB8","Font Weight":"\xD0\u2019\xD0\xB5\xD1\x81 \xD1\u02C6\xD1\u20AC\xD0\xB8\xD1\u201E\xD1\u201A\xD0\xB0","Dyslexia Font":"\xD0\xA8\xD1\u20AC\xD0\xB8\xD1\u201E\xD1\u201A \xD0\u201D\xD0\xB8\xD1\x81\xD0\xBB\xD0\xB5\xD0\xBA\xD1\x81\xD0\xB8\xD1\x8F","Language":"\xD0\xAF\xD0\xB7\xD1\u2039\xD0\xBA","Open Accessibility Menu":"\xD0\u017E\xD1\u201A\xD0\xBA\xD1\u20AC\xD1\u2039\xD1\u201A\xD1\u0152 \xD0\xBC\xD0\xB5\xD0\xBD\xD1\u017D \xD1\x81\xD0\xBF\xD0\xB5\xD1\u2020\xD0\xB8\xD0\xB0\xD0\xBB\xD1\u0152\xD0\xBD\xD1\u2039\xD1\u2026 \xD0\xB2\xD0\xBE\xD0\xB7\xD0\xBC\xD0\xBE\xD0\xB6\xD0\xBD\xD0\xBE\xD1\x81\xD1\u201A\xD0\xB5\xD0\xB9"}'
    ),
    sk: JSON.parse(
      '{"Accessibility Menu":"Menu prístupnosti","Reset settings":"Obnovi\xC5\xA5 nastavenia","Close":"Zavrie\xC5\xA5","Content Adjustments":"Nastavenia obsahu","Adjust Font Size":"Prisp\xC3\xB4sobi\xC5\xA5 ve\xC4\xBEkos\xC5\xA5 písma","Highlight Title":"Zv\xC3\xBDrazni\xC5\xA5 nadpis","Highlight Links":"Zv\xC3\xBDrazni\xC5\xA5 odkazy","Readable Font":"\xC4\u0152itate\xC4\xBEn\xC3\xA9 písmo","Color Adjustments":"Nastavenia farieb","Dark Contrast":"Tmav\xC3\xBD kontrast","Light Contrast":"Svetl\xC3\xBD kontrast","High Contrast":"Vysok\xC3\xBD kontrast","High Saturation":"Vysok\xC3\xA1 satur\xC3\xA1cia","Low Saturation":"Nízka satur\xC3\xA1cia","Monochrome":"Monochromatick\xC3\xA9","Tools":"N\xC3\xA1stroje","Reading Guide":"Sprievodca \xC4\x8Dítaním","Stop Animations":"Zastavi\xC5\xA5 anim\xC3\xA1cie","Big Cursor":"Ve\xC4\xBEk\xC3\xBD kurzor","Increase Font Size":"Zv\xC3\xA4\xC4\x8D\xC5\xA1i\xC5\xA5 ve\xC4\xBEkos\xC5\xA5 písma","Decrease Font Size":"Zmen\xC5\xA1i\xC5\xA5 ve\xC4\xBEkos\xC5\xA5 písma","Letter Spacing":"Rozostup písmen","Line Height":"V\xC3\xBD\xC5\xA1ka riadku","Font Weight":"Tlak písma","Dyslexia Font":"Písmo pre dyslexiu","Language":"Jazyk","Open Accessibility Menu":"Otvori\xC5\xA5 menu prístupnosti"}'
    ),
    sr: JSON.parse(
      '{"Accessibility Menu":"Meni Za Pristupa\xC4\x8Dnost","Reset settings":"Resetuj postavke","Close":"Zatvori","Content Adjustments":"Pode\xC5\xA1avanje Sadr\xC5\xBEaja","Adjust Font Size":"Pode\xC5\xA1avanje Veli\xC4\x8Dine Fonta","Highlight Title":"Ozna\xC4\x8Di Naslove","Highlight Links":"Ozna\xC4\x8Di Veze","Readable Font":"\xC4\u0152itljiviji Font","Color Adjustments":"Pode\xC5\xA1avanje Boja","Dark Contrast":"Tamni Kontrast","Light Contrast":"Svijetli Kontrast","High Contrast":"Visoki Kontrast","High Saturation":"Velika Zasi\xC4\u2021enost","Low Saturation":"Niska Zasi\xC4\u2021enost","Monochrome":"Jednobojni","Tools":"Alati","Reading Guide":"Vodi\xC4\x8D Za \xC4\u0152itanje","Stop Animations":"Zaustavi Animacije","Big Cursor":"Veliki Kursor","Increase Font Size":"Pove\xC4\u2021aj Veli\xC4\x8Dinu Fonta","Decrease Font Size":"Smanji Veli\xC4\x8Dinu Fonta","Letter Spacing":"Razmak Slova","Line Height":"Visina Linije","Font Weight":"Debljina Fonta","Dyslexia Font":"Font Za Disleksi\xC4\x8Dare","Language":"Jezik","Open Accessibility Menu":"Otvori Meni Za Pristupa\xC4\x8Dnost"}'
    ),
    "sr-SP": JSON.parse(
      '{"Accessibility Menu":"\xD0\u0153\xD0\xB5\xD0\xBD\xD0\xB8 \xD0\u2014\xD0\xB0 \xD0\u0178\xD1\u20AC\xD0\xB8\xD1\x81\xD1\u201A\xD1\u0192\xD0\xBF\xD0\xB0\xD1\u2021\xD0\xBD\xD0\xBE\xD1\x81\xD1\u201A","Reset settings":"\xD0 \xD0\xB5\xD1\x81\xD0\xB5\xD1\u201A\xD1\u0192\xD1\u02DC \xD0\xBF\xD0\xBE\xD1\x81\xD1\u201A\xD0\xB0\xD0\xB2\xD0\xBA\xD0\xB5","Close":"\xD0\u2014\xD0\xB0\xD1\u201A\xD0\xB2\xD0\xBE\xD1\u20AC\xD0\xB8","Content Adjustments":"\xD0\u0178\xD0\xBE\xD0\xB4\xD0\xB5\xD1\u02C6\xD0\xB0\xD0\xB2\xD0\xB0\xD1\u0161\xD0\xB5 \xD0\xA1\xD0\xB0\xD0\xB4\xD1\u20AC\xD0\xB6\xD0\xB0\xD1\u02DC\xD0\xB0","Adjust Font Size":"\xD0\u0178\xD0\xBE\xD0\xB4\xD0\xB5\xD1\u02C6\xD0\xB0\xD0\xB2\xD0\xB0\xD1\u0161\xD0\xB5 \xD0\u2019\xD0\xB5\xD0\xBB\xD0\xB8\xD1\u2021\xD0\xB8\xD0\xBD\xD0\xB5 \xD0\xA4\xD0\xBE\xD0\xBD\xD1\u201A\xD0\xB0","Highlight Title":"\xD0\u017E\xD0\xB7\xD0\xBD\xD0\xB0\xD1\u2021\xD0\xB8 \xD0\x9D\xD0\xB0\xD1\x81\xD0\xBB\xD0\xBE\xD0\xB2\xD0\xB5","Highlight Links":"\xD0\u017E\xD0\xB7\xD0\xBD\xD0\xB0\xD1\u2021\xD0\xB8 \xD0\u2019\xD0\xB5\xD0\xB7\xD0\xB5","Readable Font":"\xD0\xA7\xD0\xB8\xD1\u201A\xD1\u2122\xD0\xB8\xD0\xB2\xD0\xB8\xD1\u02DC\xD0\xB8 \xD0\xA4\xD0\xBE\xD0\xBD\xD1\u201A","Color Adjustments":"\xD0\u0178\xD0\xBE\xD0\xB4\xD0\xB5\xD1\u02C6\xD0\xB0\xD0\xB2\xD0\xB0\xD1\u0161\xD0\xB5 \xD0\u2018\xD0\xBE\xD1\u02DC\xD0\xB0","Dark Contrast":"\xD0\xA2\xD0\xB0\xD0\xBC\xD0\xBD\xD0\xB8 \xD0\u0161\xD0\xBE\xD0\xBD\xD1\u201A\xD1\u20AC\xD0\xB0\xD1\x81\xD1\u201A","Light Contrast":"\xD0\xA1\xD0\xB2\xD0\xB8\xD1\u02DC\xD0\xB5\xD1\u201A\xD0\xBB\xD0\xB8 \xD0\u0161\xD0\xBE\xD0\xBD\xD1\u201A\xD1\u20AC\xD0\xB0\xD1\x81\xD1\u201A","High Contrast":"\xD0\u2019\xD0\xB8\xD1\x81\xD0\xBE\xD0\xBA\xD0\xB8 \xD0\u0161\xD0\xBE\xD0\xBD\xD1\u201A\xD1\u20AC\xD0\xB0\xD1\x81\xD1\u201A","High Saturation":"\xD0\u2019\xD0\xB5\xD0\xBB\xD0\xB8\xD0\xBA\xD0\xB0 \xD0\u2014\xD0\xB0\xD1\x81\xD0\xB8\xD1\u203A\xD0\xB5\xD0\xBD\xD0\xBE\xD1\x81\xD1\u201A","Low Saturation":"\xD0\x9D\xD0\xB8\xD1\x81\xD0\xBA\xD0\xB0 \xD0\u2014\xD0\xB0\xD1\x81\xD0\xB8\xD1\u203A\xD0\xB5\xD0\xBD\xD0\xBE\xD1\x81\xD1\u201A","Monochrome":"\xD0\u02C6\xD0\xB5\xD0\xB4\xD0\xBD\xD0\xBE\xD0\xB1\xD0\xBE\xD1\u02DC\xD0\xBD\xD0\xB8","Tools":"\xD0\x90\xD0\xBB\xD0\xB0\xD1\u201A\xD0\xB8","Reading Guide":"\xD0\u2019\xD0\xBE\xD0\xB4\xD0\xB8\xD1\u2021 \xD0\u2014\xD0\xB0 \xD0\xA7\xD0\xB8\xD1\u201A\xD0\xB0\xD1\u0161\xD0\xB5","Stop Animations":"\xD0\u2014\xD0\xB0\xD1\u0192\xD1\x81\xD1\u201A\xD0\xB0\xD0\xB2\xD0\xB8 \xD0\x90\xD0\xBD\xD0\xB8\xD0\xBC\xD0\xB0\xD1\u2020\xD0\xB8\xD1\u02DC\xD0\xB5","Big Cursor":"\xD0\u2019\xD0\xB5\xD0\xBB\xD0\xB8\xD0\xBA\xD0\xB8 \xD0\u0161\xD1\u0192\xD1\u20AC\xD1\x81\xD0\xBE\xD1\u20AC","Increase Font Size":"\xD0\u0178\xD0\xBE\xD0\xB2\xD0\xB5\xD1\u203A\xD0\xB0\xD1\u02DC \xD0\u2019\xD0\xB5\xD0\xBB\xD0\xB8\xD1\u2021\xD0\xB8\xD0\xBD\xD1\u0192 \xD0\xA4\xD0\xBE\xD0\xBD\xD1\u201A\xD0\xB0","Decrease Font Size":"\xD0\xA1\xD0\xBC\xD0\xB0\xD1\u0161\xD0\xB8 \xD0\u2019\xD0\xB5\xD0\xBB\xD0\xB8\xD1\u2021\xD0\xB8\xD0\xBD\xD1\u0192 \xD0\xA4\xD0\xBE\xD0\xBD\xD1\u201A\xD0\xB0","Letter Spacing":"\xD0 \xD0\xB0\xD0\xB7\xD0\xBC\xD0\xB0\xD0\xBA \xD0\xA1\xD0\xBB\xD0\xBE\xD0\xB2\xD0\xB0","Line Height":"\xD0\u2019\xD0\xB8\xD1\x81\xD0\xB8\xD0\xBD\xD0\xB0 \xD0\u203A\xD0\xB8\xD0\xBD\xD0\xB8\xD1\u02DC\xD0\xB5","Font Weight":"\xD0\u201D\xD0\xB5\xD0\xB1\xD1\u2122\xD0\xB8\xD0\xBD\xD0\xB0 \xD0\xA4\xD0\xBE\xD0\xBD\xD1\u201A\xD0\xB0","Dyslexia Font":"\xD0\xA4\xD0\xBE\xD0\xBD\xD1\u201A \xD0\u2014\xD0\xB0 \xD0\u201D\xD0\xB8\xD1\x81\xD0\xBB\xD0\xB5\xD0\xBA\xD1\x81\xD0\xB8\xD1\u2021\xD0\xB0\xD1\u20AC\xD0\xB5","Language":"\xD0\u02C6\xD0\xB5\xD0\xB7\xD0\xB8\xD0\xBA","Open Accessibility Menu":"\xD0\u017E\xD1\u201A\xD0\xB2\xD0\xBE\xD1\u20AC\xD0\xB8 \xD0\u0153\xD0\xB5\xD0\xBD\xD0\xB8 \xD0\u2014\xD0\xB0 \xD0\u0178\xD1\u20AC\xD0\xB8\xD1\x81\xD1\u201A\xD1\u0192\xD0\xBF\xD0\xB0\xD1\u2021\xD0\xBD\xD0\xBE\xD1\x81\xD1\u201A"}'
    ),
    ta: JSON.parse(
      '{"Accessibility Menu":"Menu ng Accessibility","Reset settings":"I-reset ang mga setting","Close":"Isara","Content Adjustments":"Ayusin ang Nilalaman","Adjust Font Size":"I-adjust ang Laki ng Font","Highlight Title":"I-highlight ang Pamagat","Highlight Links":"I-highlight ang mga Link","Readable Font":"Madaling Basahing Font","Color Adjustments":"Ayusin ang Kulay","Dark Contrast":"Madilim na Pagkakaiba","Light Contrast":"Maliwanag na Pagkakaiba","High Contrast":"Mataas na Pagkakaiba","High Saturation":"Mataas na Saturation","Low Saturation":"Mababang Saturation","Monochrome":"Monokrom","Tools":"Mga Kasangkapan","Reading Guide":"Gabay sa Pagbabasa","Stop Animations":"Itigil ang Mga Animasyon","Big Cursor":"Malaking Cursor","Increase Font Size":"Palakihin ang Laki ng Font","Decrease Font Size":"Bawasan ang Laki ng Font","Letter Spacing":"Espasyo ng mga Titik","Line Height":"Taas ng Linya","Font Weight":"Bigat ng Font","Dyslexia Font":"Font para sa Dyslexia","Language":"Wika","Open Accessibility Menu":"Buksan ang Menu ng Accessibility"}'
    ),
    zh_Hans: JSON.parse(
      '{"Accessibility Menu":"\xE8\xBE\u2026\xE5\u0160\xA9\xE5\u0160\u0178\xE8\u0192\xBD\xE8\x8F\u0153\xE5\x8D\u2022","Reset settings":"\xE9\u2021\x8D\xE7\xBD\xAE\xE8\xAE\xBE\xE7\xBD\xAE","Close":"\xE5\u2026\xB3\xE9\u2014\xAD","Content Adjustments":"\xE5\u2020\u2026\xE5\xAE\xB9\xE8\xB0\u0192\xE6\u2022\xB4","Adjust Font Size":"\xE8\xB0\u0192\xE6\u2022\xB4\xE5\xAD\u2014\xE4\xBD\u201C\xE5\xA4\xA7\xE5\xB0\x8F","Highlight Title":"\xE6 \u2021\xE9\xA2\u02DC\xE9\xAB\u02DC\xE4\xBA\xAE","Highlight Links":"\xE9\u201C\xBE\xE6\u017D\xA5\xE9\xAB\u02DC\xE4\xBA\xAE","Readable Font":"\xE6\u02DC\u201C\xE8\xAF\xBB\xE5\xAD\u2014\xE4\xBD\u201C","Color Adjustments":"\xE8\u2030\xB2\xE5\xBD\xA9\xE8\xB0\u0192\xE6\u2022\xB4","Dark Contrast":"\xE9\xAB\u02DC\xE5\xAF\xB9\xE6\xAF\u201D\xE5\xBA\xA6\xEF\xBC\u02C6\xE9\xBB\u2018\xE8\u2030\xB2\xEF\xBC\u2030","Light Contrast":"\xE9\xAB\u02DC\xE5\xAF\xB9\xE6\xAF\u201D\xE5\xBA\xA6\xEF\xBC\u02C6\xE7\u2122\xBD\xE8\u2030\xB2\xEF\xBC\u2030","High Contrast":"\xE9\xAB\u02DC\xE5\xAF\xB9\xE6\xAF\u201D\xE5\xBA\xA6","High Saturation":"\xE9\xAB\u02DC\xE9\xA5\xB1\xE5\u2019\u0152\xE5\xBA\xA6","Low Saturation":"\xE4\xBD\u017D\xE9\xA5\xB1\xE5\u2019\u0152\xE5\xBA\xA6","Monochrome":"\xE5\x8D\u2022\xE8\u2030\xB2","Tools":"\xE6\u203A\xB4\xE5\xA4\u0161\xE8\xAE\xBE\xE7\xBD\xAE","Reading Guide":"\xE9\u02DC\u2026\xE8\xAF\xBB\xE5\xB0\xBA","Stop Animations":"\xE5\x81\u0153\xE6\xAD\xA2\xE9\u2014\xAA\xE5\u0160\xA8","Big Cursor":"\xE6\u201D\xBE\xE5\xA4\xA7\xE9\xBC \xE6 \u2021","Increase Font Size":"\xE5\xA2\u017E\xE5\u0160 \xE5\xAD\u2014\xE4\xBD\u201C\xE5\xA4\xA7\xE5\xB0\x8F","Decrease Font Size":"\xE5\u2021\x8F\xE5\xB0\x8F\xE5\xAD\u2014\xE4\xBD\u201C\xE5\xA4\xA7\xE5\xB0\x8F","Letter Spacing":"\xE5\xAD\u2014\xE6\xAF\x8D\xE9\u2014\xB4\xE8\xB7\x9D","Line Height":"\xE8\xA1\u0152\xE8\xB7\x9D","Font Weight":"\xE5\xAD\u2014\xE9\u2021\x8D","Dyslexia Font":"\xE9\u02DC\u2026\xE8\xAF\xBB\xE9\u0161\u0153\xE7\xA2\x8D\xE5\xAD\u2014\xE4\xBD\u201C","Language":"\xE8\xAF\xAD\xE8\xA8\u20AC","Open Accessibility Menu":"\xE6\u2030\u201C\xE5\xBC\u20AC\xE8\xBE\u2026\xE5\u0160\xA9\xE5\u0160\u0178\xE8\u0192\xBD\xE8\x8F\u0153\xE5\x8D\u2022"}'
    ),
    zh_Hant: JSON.parse(
      '{"Accessibility Menu":"\xE8\xBC\u201D\xE5\u0160\xA9\xE5\u0160\u0178\xE8\u0192\xBD\xE8\x8F\u0153\xE5\u2013\xAE","Reset settings":"\xE9\u2021\x8D\xE7\xBD\xAE\xE8\xA8\xAD\xE5\xAE\u0161","Close":"\xE9\u2014\u0153\xE9\u2013\u2030","Content Adjustments":"\xE5\u2026\xA7\xE5\xAE\xB9\xE8\xAA\xBF\xE6\u2022\xB4","Adjust Font Size":"\xE8\xAA\xBF\xE6\u2022\xB4\xE5\xAD\u2014\xE9\xAB\u201D\xE5\xA4\xA7\xE5\xB0\x8F","Highlight Title":"\xE6\xA8\u2122\xE9\xA1\u0152\xE9\xAB\u02DC\xE4\xBA\xAE","Highlight Links":"\xE9\u20AC\xA3\xE7\xB5\x90\xE9\xAB\u02DC\xE4\xBA\xAE","Readable Font":"\xE6\u02DC\u201C\xE8\xAE\u20AC\xE5\xAD\u2014\xE9\xAB\u201D","Color Adjustments":"\xE8\u2030\xB2\xE5\xBD\xA9\xE8\xAA\xBF\xE6\u2022\xB4","Dark Contrast":"\xE9\xAB\u02DC\xE5\xB0\x8D\xE6\xAF\u201D\xE5\xBA\xA6\xEF\xBC\u02C6\xE9\xBB\u2018\xE8\u2030\xB2\xEF\xBC\u2030","Light Contrast":"\xE9\xAB\u02DC\xE5\xB0\x8D\xE6\xAF\u201D\xE5\xBA\xA6\xEF\xBC\u02C6\xE7\u2122\xBD\xE8\u2030\xB2\xEF\xBC\u2030","High Contrast":"\xE9\xAB\u02DC\xE5\xB0\x8D\xE6\xAF\u201D\xE5\xBA\xA6","High Saturation":"\xE9\xAB\u02DC\xE9\xA3\xBD\xE5\u2019\u0152\xE5\xBA\xA6","Low Saturation":"\xE4\xBD\u017D\xE9\xA3\xBD\xE5\u2019\u0152\xE5\xBA\xA6","Monochrome":"\xE5\u2013\xAE\xE8\u2030\xB2","Tools":"\xE6\u203A\xB4\xE5\xA4\u0161\xE8\xA8\xAD\xE5\xAE\u0161","Reading Guide":"\xE9\u2013\xB1\xE8\xAE\u20AC\xE5\xB0\xBA","Stop Animations":"\xE5\x81\u0153\xE6\xAD\xA2\xE9\u2013\u0192\xE5\u2039\u2022","Big Cursor":"\xE6\u201D\xBE\xE5\xA4\xA7\xE6\xBB\u2018\xE9\xBC ","Increase Font Size":"\xE5\xA2\u017E\xE5\u0160 \xE5\xAD\u2014\xE9\xAB\u201D\xE5\xA4\xA7\xE5\xB0\x8F","Decrease Font Size":"\xE6\xB8\u203A\xE5\xB0\x8F\xE5\xAD\u2014\xE9\xAB\u201D\xE5\xA4\xA7\xE5\xB0\x8F","Letter Spacing":"\xE5\xAD\u2014\xE6\xAF\x8D\xE9\u2013\u201C\xE8\xB7\x9D","Line Height":"\xE8\xA1\u0152\xE8\xB7\x9D","Font Weight":"\xE5\xAD\u2014\xE9\u2021\x8D","Dyslexia Font":"\xE9\u2013\xB1\xE8\xAE\u20AC\xE9\u0161\u0153\xE7\xA4\u2122\xE5\xAD\u2014\xE9\xAB\u201D","Language":"\xE8\xAA\u017E\xE8\xA8\u20AC","Open Accessibility Menu":"\xE6\u2030\u201C\xE9\u2013\u2039\xE8\xBC\u201D\xE5\u0160\xA9\xE5\u0160\u0178\xE8\u0192\xBD\xE8\x8F\u0153\xE5\u2013\xAE"}'
    ),
    vi: JSON.parse(
      '{"Accessibility Menu":"Menu Truy c\xE1\xBA\xADp","Reset settings":"\xC4\x90\xE1\xBA\xB7t l\xE1\xBA\xA1i c\xC3 i \xC4\u2018\xE1\xBA\xB7t","Close":"\xC4\x90óng","Content Adjustments":"\xC4\x90i\xE1\xBB\x81u ch\xE1\xBB\u2030nh N\xE1\xBB\u2122i dung","Adjust Font Size":"\xC4\x90i\xE1\xBB\x81u ch\xE1\xBB\u2030nh Kích th\xC6\xB0\xE1\xBB\u203Ac Font ch\xE1\xBB\xAF","Highlight Title":"\xC4\x90\xC3\xA1nh d\xE1\xBA\xA5u Ti\xC3\xAAu \xC4\u2018\xE1\xBB\x81","Highlight Links":"\xC4\x90\xC3\xA1nh d\xE1\xBA\xA5u Li\xC3\xAAn k\xE1\xBA\xBFt","Readable Font":"Font ch\xE1\xBB\xAF D\xE1\xBB\u2026 \xC4\u2018\xE1\xBB\x8Dc","Color Adjustments":"\xC4\x90i\xE1\xBB\x81u ch\xE1\xBB\u2030nh M\xC3 u s\xE1\xBA\xAFc","Dark Contrast":"T\xC6\xB0\xC6\xA1ng ph\xE1\xBA\xA3n T\xE1\xBB\u2018i","Light Contrast":"T\xC6\xB0\xC6\xA1ng ph\xE1\xBA\xA3n S\xC3\xA1ng","High Contrast":"T\xC6\xB0\xC6\xA1ng ph\xE1\xBA\xA3n Cao","High Saturation":"B\xC3\xA3o h\xC3\xB2a Cao","Low Saturation":"B\xC3\xA3o h\xC3\xB2a Th\xE1\xBA\xA5p","Monochrome":"\xC4\x90\xC6\xA1n s\xE1\xBA\xAFc","Tools":"C\xC3\xB4ng c\xE1\xBB\xA5","Reading Guide":"H\xC6\xB0\xE1\xBB\u203Ang d\xE1\xBA\xABn \xC4\x90\xE1\xBB\x8Dc","Stop Animations":"D\xE1\xBB\xABng Ho\xE1\xBA\xA1t h\xC3\xACnh","Big Cursor":"Con tr\xE1\xBB\x8F L\xE1\xBB\u203An","Increase Font Size":"T\xC4\u0192ng Kích th\xC6\xB0\xE1\xBB\u203Ac Font ch\xE1\xBB\xAF","Decrease Font Size":"Gi\xE1\xBA\xA3m Kích th\xC6\xB0\xE1\xBB\u203Ac Font ch\xE1\xBB\xAF","Letter Spacing":"Kho\xE1\xBA\xA3ng c\xC3\xA1ch Ch\xE1\xBB\xAF","Line Height":"\xC4\x90\xE1\xBB\u2122 Cao d\xC3\xB2ng","Font Weight":"\xC4\x90\xE1\xBB\u2122 \xC4\x90\xE1\xBA\xADm c\xE1\xBB\xA7a Font ch\xE1\xBB\xAF","Dyslexia Font":"Font ch\xE1\xBB\xAF Cho ng\xC6\xB0\xE1\xBB\x9Di có Khuy\xE1\xBA\xBFt t\xE1\xBA\xADt \xC4\u2018\xE1\xBB\x8Dc hi\xE1\xBB\u0192u","Language":"Ng\xC3\xB4n ng\xE1\xBB\xAF","Open Accessibility Menu":"M\xE1\xBB\u0178 Menu Truy c\xE1\xBA\xADp"}'
    ),
  };
  var _ = [{ code: "es", label: "Español (Spanish)" }];
  var Y = function (t, e) {
    var n = {};
    for (var i in t) {
      if (Object.prototype.hasOwnProperty.call(t, i) && e.indexOf(i) < 0) {
        n[i] = t[i];
      }
    }
    if (t != null && typeof Object.getOwnPropertySymbols == "function") {
      var a = 0;
      for (i = Object.getOwnPropertySymbols(t); a < i.length; a++) {
        if (
          e.indexOf(i[a]) < 0 &&
          Object.prototype.propertyIsEnumerable.call(t, i[a])
        ) {
          n[i[a]] = t[i[a]];
        }
      }
    }
    return n;
  };
  var X = function () {
    X =
      Object.assign ||
      function (t) {
        var e;
        var n = 1;
        for (var i = arguments.length; n < i; n++) {
          for (var a in (e = arguments[n])) {
            if (Object.prototype.hasOwnProperty.call(e, a)) {
              t[a] = e[a];
            }
          }
        }
        return t;
      };
    return X.apply(this, arguments);
  };
  var $ = function () {
    $ =
      Object.assign ||
      function (t) {
        var e;
        var n = 1;
        for (var i = arguments.length; n < i; n++) {
          for (var a in (e = arguments[n])) {
            if (Object.prototype.hasOwnProperty.call(e, a)) {
              t[a] = e[a];
            }
          }
        }
        return t;
      };
    return $.apply(this, arguments);
  };
  var tt = { lang: "en", position: "bottom-left" };
  document.addEventListener("readystatechange", function t() {
    var e;
    var n;
    var i;
    var a;
    var o;
    if (
      document.readyState === "complete" ||
      document.readyState === "interactive"
    ) {
      i = nt("lang");
      a = nt("position");
      o = nt("offset");
      if (!i) {
        i =
          (n =
            (e =
              document === null || document === void 0
                ? void 0
                : document.querySelector("html")) === null || e === void 0
              ? void 0
              : e.getAttribute("lang")) === null || n === void 0
            ? void 0
            : n.replace(/[_-].*/, "");
      }
      if (
        !i &&
        typeof navigator != "undefined" &&
        (navigator === null || navigator === void 0
          ? void 0
          : navigator.language)
      ) {
        i =
          navigator === null || navigator === void 0
            ? void 0
            : navigator.language;
      }
      if (o) {
        o = o.split(",").map(function (t) {
          return parseInt(t);
        });
      }
      et({ lang: i, position: a, offset: o });
      document.removeEventListener("readystatechange", t);
    }
  });

  document.addEventListener("turbolinks:load", function() {
    var e;
    var n;
    var i;
    var a;
    var o;
    if (
      document.readyState === "complete" ||
      document.readyState === "interactive"
    ) {
      i = nt("lang");
      a = nt("position");
      o = nt("offset");
      if (!i) {
        i =
          (n =
            (e =
              document === null || document === void 0
                ? void 0
                : document.querySelector("html")) === null || e === void 0
              ? void 0
              : e.getAttribute("lang")) === null || n === void 0
            ? void 0
            : n.replace(/[_-].*/, "");
      }
      if (
        !i &&
        typeof navigator != "undefined" &&
        (navigator === null || navigator === void 0
          ? void 0
          : navigator.language)
      ) {
        i =
          navigator === null || navigator === void 0
            ? void 0
            : navigator.language;
      }
      if (o) {
        o = o.split(",").map(function (t) {
          return parseInt(t);
        });
      }
      et({ lang: i, position: a, offset: o });
      document.removeEventListener("readystatechange", t);
    }
  });
})();
