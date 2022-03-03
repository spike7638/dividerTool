// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Caml from "rescript/lib/es6/caml.js";
import * as List from "rescript/lib/es6/list.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Pervasives from "rescript/lib/es6/pervasives.js";

function converterProducer(w, g, t, n) {
  if (n >= (w - t) / g) {
    return w - t;
  } else {
    return n * g;
  }
}

function classifyH(y, spans) {
  return List.map((function (s) {
                return {
                        m: s.p1.yi === y || s.p2.yi === y ? /* Terminate */1 : /* Cross */0,
                        pos: s.p1.xi
                      };
              }), spans);
}

function convertHelper(thickness, ss, sf, n, meets, gToWH) {
  if (!meets) {
    return Pervasives.failwith("Empty meets-list in convertHelper!");
  }
  var match = meets.tl;
  var match$1 = meets.hd;
  var k = match$1.pos;
  var q = match$1.m;
  if (match) {
    var tl = match.tl;
    var match$2 = match.hd;
    var l = match$2.pos;
    var r = match$2.m;
    if (k !== n) {
      return Pervasives.failwith("Bad position in spanSummary!");
    }
    var fill = {
      TAG: /* G */6,
      _0: Curry._1(gToWH, l) - Curry._1(gToWH, k)
    };
    var fillShort = {
      TAG: /* G */6,
      _0: Curry._1(gToWH, l) - (Curry._1(gToWH, k) + thickness)
    };
    switch (q) {
      case /* Cross */0 :
          if (k !== ss) {
            return {
                    hd: {
                      TAG: /* XL */3,
                      _0: thickness
                    },
                    tl: {
                      hd: fillShort,
                      tl: convertHelper(thickness, ss, sf, l, {
                            hd: {
                              m: r,
                              pos: l
                            },
                            tl: tl
                          }, gToWH)
                    }
                  };
          } else {
            return {
                    hd: {
                      TAG: /* T */5,
                      _0: thickness
                    },
                    tl: {
                      hd: fillShort,
                      tl: convertHelper(thickness, ss, sf, l, {
                            hd: {
                              m: r,
                              pos: l
                            },
                            tl: tl
                          }, gToWH)
                    }
                  };
          }
      case /* Terminate */1 :
          if (k === ss) {
            return {
                    hd: {
                      TAG: /* CL */1,
                      _0: thickness
                    },
                    tl: {
                      hd: fillShort,
                      tl: convertHelper(thickness, ss, sf, l, {
                            hd: {
                              m: r,
                              pos: l
                            },
                            tl: tl
                          }, gToWH)
                    }
                  };
          } else {
            return {
                    hd: {
                      TAG: /* S */4,
                      _0: thickness
                    },
                    tl: {
                      hd: fillShort,
                      tl: convertHelper(thickness, ss, sf, l, {
                            hd: {
                              m: r,
                              pos: l
                            },
                            tl: tl
                          }, gToWH)
                    }
                  };
          }
      case /* End */2 :
          return {
                  hd: fill,
                  tl: convertHelper(thickness, ss, sf, l, {
                        hd: {
                          m: r,
                          pos: l
                        },
                        tl: tl
                      }, gToWH)
                };
      
    }
  } else {
    if (k !== n) {
      return Pervasives.failwith("Bad position in spanSummary!");
    }
    switch (q) {
      case /* Cross */0 :
          if (sf !== n) {
            return {
                    hd: {
                      TAG: /* XL */3,
                      _0: thickness
                    },
                    tl: {
                      hd: {
                        TAG: /* G */6,
                        _0: Curry._1(gToWH, sf) - Curry._1(gToWH, n)
                      },
                      tl: /* [] */0
                    }
                  };
          } else {
            return {
                    hd: {
                      TAG: /* T */5,
                      _0: thickness
                    },
                    tl: /* [] */0
                  };
          }
      case /* Terminate */1 :
          if (sf !== n) {
            return {
                    hd: {
                      TAG: /* S */4,
                      _0: thickness
                    },
                    tl: {
                      hd: {
                        TAG: /* G */6,
                        _0: Curry._1(gToWH, sf) - Curry._1(gToWH, n)
                      },
                      tl: /* [] */0
                    }
                  };
          } else {
            return {
                    hd: {
                      TAG: /* CL */1,
                      _0: thickness
                    },
                    tl: /* [] */0
                  };
          }
      case /* End */2 :
          return {
                  hd: {
                    TAG: /* G */6,
                    _0: Curry._1(gToWH, sf) + thickness - Curry._1(gToWH, n)
                  },
                  tl: /* [] */0
                };
      
    }
  }
}

function enhance(s, flist) {
  if (!flist) {
    return {
            hd: {
              m: /* End */2,
              pos: s.p1.xi
            },
            tl: {
              hd: {
                m: /* End */2,
                pos: s.p2.xi
              },
              tl: /* [] */0
            }
          };
  }
  var nFeature = List.length(flist);
  var lastFeature = List.nth(flist, nFeature - 1 | 0);
  var fixedLast = lastFeature.pos !== s.p2.xi ? Pervasives.$at(flist, {
          hd: {
            m: /* End */2,
            pos: s.p2.xi
          },
          tl: /* [] */0
        }) : flist;
  if (flist.hd.pos !== s.p1.xi) {
    return {
            hd: {
              m: /* End */2,
              pos: s.p1.xi
            },
            tl: fixedLast
          };
  } else {
    return fixedLast;
  }
}

function cleanup(_ss) {
  while(true) {
    var ss = _ss;
    if (!ss) {
      return /* [] */0;
    }
    var q = ss.hd;
    if (!ss.tl) {
      return {
              hd: q,
              tl: /* [] */0
            };
    }
    if (q.TAG !== /* G */6) {
      return {
              hd: q,
              tl: cleanup(ss.tl)
            };
    }
    var match = ss.tl;
    var b = match.hd;
    if (b.TAG !== /* G */6) {
      return {
              hd: q,
              tl: cleanup(ss.tl)
            };
    }
    _ss = {
      hd: {
        TAG: /* G */6,
        _0: q._0 + b._0
      },
      tl: match.tl
    };
    continue ;
  };
}

function convertOne(s, spans, settings) {
  var span1 = classifyH(s.p1.yi, spans);
  var spanSummaries = enhance(s, span1);
  var partial_arg = settings.thickness;
  var partial_arg$1 = settings.spacing;
  var partial_arg$2 = settings.width;
  var gToWH = function (param) {
    return converterProducer(partial_arg$2, partial_arg$1, partial_arg, param);
  };
  return cleanup(convertHelper(settings.thickness, s.p1.xi, s.p2.xi, s.p1.xi, spanSummaries, gToWH));
}

function swap(s) {
  return {
          p1: s.p2,
          p2: s.p1
        };
}

function isHorizontal(s) {
  return s.p1.yi === s.p2.yi;
}

function meets(h, v) {
  if (h.p1.yi >= v.p1.yi && h.p1.yi <= v.p2.yi && h.p1.xi <= v.p1.xi) {
    return h.p2.xi >= v.p1.xi;
  } else {
    return false;
  }
}

function polish(s) {
  if (isHorizontal(s)) {
    if (s.p1.xi < s.p2.xi) {
      return s;
    } else {
      return swap(s);
    }
  } else if (s.p1.yi < s.p2.yi) {
    return s;
  } else {
    return swap(s);
  }
}

function flipPoint(p) {
  return {
          xi: p.yi,
          yi: p.xi
        };
}

function flipSpan(s) {
  return polish({
              p1: flipPoint(s.p1),
              p2: flipPoint(s.p2)
            });
}

function flipSpanList(s) {
  return List.map(flipSpan, s);
}

function flipFeature(q) {
  switch (q.TAG | 0) {
    case /* CU */0 :
        return {
                TAG: /* CL */1,
                _0: q._0
              };
    case /* CL */1 :
        return {
                TAG: /* CU */0,
                _0: q._0
              };
    case /* XU */2 :
        return {
                TAG: /* XL */3,
                _0: q._0
              };
    case /* XL */3 :
        return {
                TAG: /* XU */2,
                _0: q._0
              };
    default:
      return q;
  }
}

function flipFeatureList(x) {
  return List.map(flipFeature, x);
}

function flipFeatureListList(x) {
  return List.map(flipFeatureList, x);
}

function prepAndConvert(hSpans, vSpans, settings) {
  var qq = function (s) {
    var crosses = List.filter(function (v) {
            return meets(s, v);
          })(vSpans);
    var cross2 = List.sort((function (s1, s2) {
            return Caml.caml_int_compare(s1.p1.xi, s2.p1.xi);
          }), crosses);
    return convertOne(s, cross2, settings);
  };
  return List.fold_right((function (x, r) {
                return {
                        hd: qq(x),
                        tl: r
                      };
              }), hSpans, /* [] */0);
}

function convertAll(drawing, settings) {
  var d = List.map(polish, drawing);
  var dH = List.filter(isHorizontal)(d);
  var dV = List.filter(function (x) {
          return !isHorizontal(x);
        })(d);
  var fH = prepAndConvert(dH, dV, settings);
  var fV = List.map(flipFeatureList, prepAndConvert(List.map(flipSpan, dV), List.map(flipSpan, dH), settings));
  return Pervasives.$at(fH, fV);
}

function convertAll2(drawing, s) {
  var d = List.map(polish, drawing);
  var dH = List.filter(isHorizontal)(d);
  var dV = List.filter(function (x) {
          return !isHorizontal(x);
        })(d);
  var fH = prepAndConvert(dH, dV, s);
  var fV = List.map(flipFeatureList, prepAndConvert(List.map(flipSpan, dV), List.map(flipSpan, dH), s));
  return [
          fH,
          fV
        ];
}

function soi(prim) {
  return String(prim);
}

function string_of_feature(q) {
  switch (q.TAG | 0) {
    case /* CU */0 :
        return "CU(" + (q._0.toString() + ")");
    case /* CL */1 :
        return "CL(" + (q._0.toString() + ")");
    case /* XU */2 :
        return "XU(" + (q._0.toString() + ")");
    case /* XL */3 :
        return "XL(" + (q._0.toString() + ")");
    case /* S */4 :
        return "S(" + (q._0.toString() + ")");
    case /* T */5 :
        return "T(" + (q._0.toString() + ")");
    case /* G */6 :
        return "G(" + (q._0.toString() + ")");
    case /* D */7 :
        return "D(" + (q._0.toString() + ")");
    
  }
}

function string_of_direction(q) {
  if (q) {
    return "V";
  } else {
    return "H";
  }
}

function string_of_meeting(q) {
  switch (q) {
    case /* Cross */0 :
        return "Cross";
    case /* Terminate */1 :
        return "Term";
    case /* End */2 :
        return "End";
    
  }
}

function string_of_span_summaryi(param) {
  return "ss: " + (string_of_meeting(param.m) + (", " + String(param.pos)));
}

function spanList_of_strokeList(sl) {
  return List.map((function (s) {
                return s.sp;
              }), sl);
}

function converter(sl, settings) {
  return convertAll(List.map((function (s) {
                    return s.sp;
                  }), sl), settings);
}

function stringOfStrokeList(sl, settings) {
  var c = convertAll(List.map((function (s) {
              return s.sp;
            }), sl), settings);
  var make_string = function (sl) {
    return List.fold_right((function (x, s) {
                  return string_of_feature(x) + ", " + s;
                }), sl, "");
  };
  return List.fold_right((function (x, s) {
                return make_string(x) + ("\n" + s);
              }), c, "");
}

function drawingToDivider(st, drawing) {
  var settings = st.data;
  var d1 = List.map((function (s) {
          return s.sp;
        }), drawing);
  List.filter(isHorizontal)(d1);
  List.filter(function (x) {
          return !isHorizontal(x);
        })(d1);
  var sp0_height = settings.height;
  var sp0_dipSizeH = settings.height * settings.dipPercentageH / 100.0;
  var sp0_dipSizeV = settings.height * settings.dipPercentageV / 100.0;
  var sp0_t = settings.thickness;
  var sp0 = {
    height: sp0_height,
    dipSizeH: sp0_dipSizeH,
    dipSizeV: sp0_dipSizeV,
    t: sp0_t,
    pinCount: 5,
    tabFraction: 0.3
  };
  var match = convertAll2(d1, st.data);
  var horiz0 = List.mapi((function (i, fl) {
          return {
                  isHorizontal: true,
                  geom: fl,
                  name: "H" + String(i)
                };
        }), match[0]);
  var vert0 = List.mapi((function (i, fl) {
          return {
                  isHorizontal: false,
                  geom: fl,
                  name: "V" + String(i)
                };
        }), match[1]);
  return {
          horiz: horiz0,
          vert: vert0,
          spec: sp0
        };
}

function sof(prim) {
  return prim.toString();
}

function checkPanelhelper(_lst) {
  while(true) {
    var lst = _lst;
    if (!lst) {
      return true;
    }
    switch (lst.hd.TAG | 0) {
      case /* CU */0 :
      case /* CL */1 :
          return false;
      default:
        _lst = lst.tl;
        continue ;
    }
  };
}

function checkPanel(lst) {
  if (!lst) {
    return false;
  }
  if (lst.hd.TAG === /* G */6) {
    return false;
  }
  if (!lst.tl) {
    return false;
  }
  var match = List.rev(lst);
  if (match && match.hd.TAG === /* G */6) {
    return false;
  } else {
    return checkPanelhelper(lst);
  }
}

function panelLength(param) {
  if (param) {
    return param.hd._0 + panelLength(param.tl);
  } else {
    return 0.0;
  }
}

function pinHelper(start, fin, ht, wid, x) {
  if (start > fin) {
    return /* [] */0;
  }
  var s = start;
  return {
          hd: {
            height: ht,
            width: wid,
            lowerLeft: [
              x,
              s * ht
            ],
            isDip: false
          },
          tl: pinHelper(start + 2 | 0, fin, ht, wid, x)
        };
}

function pinU(x, c, s) {
  if (c.TAG !== /* CL */1) {
    return Pervasives.failwith("Bad upper-pin specification");
  }
  var pinHeight = s.height / ((s.pinCount << 1) + 1 | 0);
  return pinHelper(0, (s.pinCount << 1), pinHeight, c._0, x);
}

function pinL(x, c, s) {
  if (c.TAG !== /* CU */0) {
    return Pervasives.failwith("Bad lower-pin specification");
  }
  var pinHeight = s.height / ((s.pinCount << 1) + 1 | 0);
  return pinHelper(1, (s.pinCount << 1) - 1 | 0, pinHeight, c._0, x);
}

function outerBox(lst, spec) {
  return {
          height: spec.height,
          width: panelLength(lst),
          lowerLeft: [
            0.0,
            0.0
          ],
          isDip: false
        };
}

function tabBoxes(x, c, s) {
  if (c.TAG !== /* T */5) {
    return Pervasives.failwith("Bad tab specification");
  }
  var f = c._0;
  var q = (1.0 - s.tabFraction) / 2.0;
  var yBot = q * s.height;
  var yTop = (1.0 - q) * s.height;
  return {
          hd: {
            height: yBot,
            width: f,
            lowerLeft: [
              x,
              0.0
            ],
            isDip: false
          },
          tl: {
            hd: {
              height: yBot,
              width: f,
              lowerLeft: [
                x,
                yTop
              ],
              isDip: false
            },
            tl: /* [] */0
          }
        };
}

function tabSlots(x, c, s) {
  if (c.TAG !== /* S */4) {
    return Pervasives.failwith("Bad slot specification");
  }
  var q = (1.0 - s.tabFraction) / 2.0;
  var yBot = q * s.height;
  var yTop = (1.0 - q) * s.height;
  return {
          hd: {
            height: yTop - yBot,
            width: c._0,
            lowerLeft: [
              x,
              yBot
            ],
            isDip: false
          },
          tl: /* [] */0
        };
}

function slitL(x, c, s) {
  if (c.TAG !== /* XU */2) {
    return Pervasives.failwith("Bad lower-slit specification");
  }
  var slotHeight = 0.5 * s.height;
  return {
          hd: {
            height: slotHeight,
            width: c._0,
            lowerLeft: [
              x,
              slotHeight
            ],
            isDip: false
          },
          tl: /* [] */0
        };
}

function slitU(x, c, s) {
  if (c.TAG !== /* XL */3) {
    return Pervasives.failwith("Bad upper-slit specification");
  }
  var slotHeight = 0.5 * s.height;
  return {
          hd: {
            height: slotHeight,
            width: c._0,
            lowerLeft: [
              x,
              0.0
            ],
            isDip: false
          },
          tl: /* [] */0
        };
}

function stringOfBox(bs) {
  var h = bs.height;
  var w = bs.width;
  var match = bs.lowerLeft;
  return "(" + (match[0].toString() + (", " + (match[1].toString() + ("); w = " + (w.toString() + (", h = " + (h.toString() + "\n")))))));
}

function dip(x, f, height, dipSize) {
  var xs = x + 0.5;
  var xf = x + f - 0.5;
  var w = xf - xs;
  if (w < 4.0 * dipSize) {
    return Pervasives.failwith("Impossible dip length!");
  } else {
    return {
            hd: {
              height: height,
              width: xf - xs,
              lowerLeft: [
                xs,
                height - dipSize
              ],
              isDip: true
            },
            tl: /* [] */0
          };
  }
}

function allBoxesHelper(_panel, sp, _x, isHorizontal) {
  while(true) {
    var x = _x;
    var panel = _panel;
    if (!panel) {
      return /* [] */0;
    }
    var f = panel.hd;
    switch (f.TAG | 0) {
      case /* CU */0 :
          var f$1 = f._0;
          return Pervasives.$at(pinL(x, {
                          TAG: /* CU */0,
                          _0: f$1
                        }, sp), allBoxesHelper(panel.tl, sp, x + f$1, isHorizontal));
      case /* CL */1 :
          var f$2 = f._0;
          return Pervasives.$at(pinU(x, {
                          TAG: /* CL */1,
                          _0: f$2
                        }, sp), allBoxesHelper(panel.tl, sp, x + f$2, isHorizontal));
      case /* XU */2 :
          var f$3 = f._0;
          return Pervasives.$at(slitL(x, {
                          TAG: /* XU */2,
                          _0: f$3
                        }, sp), allBoxesHelper(panel.tl, sp, x + f$3, isHorizontal));
      case /* XL */3 :
          var f$4 = f._0;
          return Pervasives.$at(slitU(x, {
                          TAG: /* XL */3,
                          _0: f$4
                        }, sp), allBoxesHelper(panel.tl, sp, x + f$4, isHorizontal));
      case /* S */4 :
          var f$5 = f._0;
          return Pervasives.$at(tabSlots(x, {
                          TAG: /* S */4,
                          _0: f$5
                        }, sp), allBoxesHelper(panel.tl, sp, x + f$5, isHorizontal));
      case /* T */5 :
          var f$6 = f._0;
          return Pervasives.$at(tabBoxes(x, {
                          TAG: /* T */5,
                          _0: f$6
                        }, sp), allBoxesHelper(panel.tl, sp, x + f$6, isHorizontal));
      case /* G */6 :
          _x = x + f._0;
          _panel = panel.tl;
          continue ;
      case /* D */7 :
          var f$7 = f._0;
          return Pervasives.$at(dip(x, f$7, sp.height, isHorizontal ? sp.dipSizeH : sp.dipSizeV), allBoxesHelper(panel.tl, sp, x + f$7, isHorizontal));
      
    }
  };
}

function allBoxes(panel, sp, isHorizontal) {
  return {
          hd: outerBox(panel, sp),
          tl: allBoxesHelper(panel, sp, 0.0, isHorizontal)
        };
}

function textOfPoint(x, y) {
  return (72.0 * x).toString() + (", " + ((72.0 * y).toString() + " "));
}

function ps(name, x, y) {
  return Pervasives.print_string(name + (": " + (x.toString() + (", " + (y.toString() + "\n")))));
}

function boxToPathD(bs, sp, dipSize) {
  var helper = function (xs, ys, xq, yq, xm, ym, xt, yt, xf, yf) {
    return "M " + (textOfPoint(xs, ys) + ("Q " + (textOfPoint(xq, yq) + ("  " + (textOfPoint(xm, ym) + ("T " + (textOfPoint(xt, yt) + ("M " + textOfPoint(xf, yf)))))))));
  };
  if (bs.isDip) {
    var match = bs.lowerLeft;
    var ys = bs.height;
    var xs = match[0];
    var xq = xs + 0.875 * dipSize;
    var xm = xs + dipSize;
    var ym = ys - dipSize / 2.0;
    var xt = xs + 2 * dipSize;
    var yt = ys - dipSize;
    var xf = xs + 2 * dipSize;
    var yf = ys - dipSize;
    var st1 = helper(xs, ys, xq, ys, xm, ym, xt, yt, xf, yf) + " ";
    var xs2 = bs.lowerLeft[0] + bs.width;
    var ys2 = bs.height;
    var xq2 = xs2 - 0.875 * dipSize;
    var xm2 = xs2 - dipSize;
    var ym2 = ys2 - dipSize / 2.0;
    var xt2 = xs2 - 2 * dipSize;
    var yt2 = ys2 - dipSize;
    var xf2 = xs2 - 2 * dipSize;
    var yf2 = ys2 - dipSize;
    var st2 = "M " + (textOfPoint(xf, yf) + ("L " + textOfPoint(xf2, yf2)));
    var st3 = helper(xs2, ys2, xq2, ys2, xm2, ym2, xt2, yt2, xf2, yf2) + " ";
    return st1 + (st2 + st3);
  }
  var hs = (72.0 * bs.height).toString();
  var ws = (72.0 * bs.width).toString();
  var match$1 = bs.lowerLeft;
  var xs$1 = (72.0 * match$1[0]).toString();
  var ys$1 = (72.0 * match$1[1]).toString();
  return "M " + (xs$1 + (", " + (ys$1 + ("  v " + (hs + ("  h " + (ws + ("  v -" + (hs + "  z\n")))))))));
}

function boxListToPathD(bsl, sp, dipSize) {
  if (bsl) {
    return boxToPathD(bsl.hd, sp, dipSize) + boxListToPathD(bsl.tl, sp, dipSize);
  } else {
    return "";
  }
}

function boxListToPath(bList, sp, dipSize) {
  var dSpec = "d=\" \n" + (boxListToPathD(bList, sp, dipSize) + "\"");
  return "<path id=\"\" vector-effect=\"non-scaling-stroke\" class=\"st0\" " + (dSpec + "/>\n");
}

function text(x, y, s) {
  return "\n<text x=\"" + (Pervasives.string_of_float(x) + ("\" y=\"" + (Pervasives.string_of_float(y) + ("\" fill=\"#00FF00\" >" + (s + "</text>\n")))));
}

function panelToPath(p, sp, x, y, dipSize) {
  var bList = allBoxes(p.geom, sp, p.isHorizontal);
  var dSpec = "d=\" \n" + (boxListToPathD(bList, sp, dipSize) + "\"");
  var head = "<g transform=\"translate(" + (x.toString() + (", " + (y.toString() + (")\">\n" + (text(20.0, 20.0, p.name) + ("<path id=\"" + (p.name + "\" vector-effect=\"non-scaling-stroke\" class=\"st0\" ")))))));
  return head + (dSpec + "/>\n</g>\n");
}

function dividerToSVG(dr) {
  var panelCount = List.length(dr.horiz) + List.length(dr.vert) | 0;
  var panelWidth = 72.0 * List.fold_left((function (x, y) {
          if (x > y) {
            return x;
          } else {
            return y;
          }
        }), 0.0, List.map((function (p) {
              return panelLength(p.geom);
            }), List.append(dr.horiz, dr.vert))) | 0;
  var windowHeight = 20.0 + panelCount * 72.0 * (dr.spec.height + 0.125) | 0;
  var shapeString = "0 0 " + (String(20 + panelWidth | 0) + (" " + String(windowHeight)));
  var svgFront = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<!-- Generator: Adobe Illustrator 24.1.2, SVG Export Plug-In . SVG Version: 6.00 Build 0)  -->\n<svg version=\"1.1\" id=\"Layer_1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" \nx=\"0px\" y=\"0px\" viewBox=\"" + (shapeString + (" \" style=\"enable-background:new " + (shapeString + ";\" xml:space=\"preserve\"><style type=\"text/css\">\n.st0{fill:none;stroke:#FF0000;stroke-width:7.200000e-01;stroke-linecap:round;stroke-miterlimit:288;}\n</style>\n")));
  var panelPathsH = List.mapi((function (i, pan) {
          return panelToPath(pan, dr.spec, 10.0, 10.0 + i * 72.0 * (dr.spec.height + 0.125), dr.spec.dipSizeH);
        }), dr.horiz);
  var offset = (List.length(dr.horiz) + 0.2) * 72.0 * (dr.spec.height + 0.125);
  var panelPathsV = List.mapi((function (i, pan) {
          return panelToPath(pan, dr.spec, 10.0, 10.0 + i * 72.0 * (dr.spec.height + 0.125) + offset, dr.spec.dipSizeV);
        }), dr.vert);
  var back = List.fold_right((function (s1, s2) {
          return s1 + s2;
        }), List.append(panelPathsH, panelPathsV), "</svg>\n");
  return svgFront + back;
}

var stringOfDivider = dividerToSVG;

export {
  converterProducer ,
  classifyH ,
  convertHelper ,
  enhance ,
  cleanup ,
  convertOne ,
  swap ,
  isHorizontal ,
  meets ,
  polish ,
  flipPoint ,
  flipSpan ,
  flipSpanList ,
  flipFeature ,
  flipFeatureList ,
  flipFeatureListList ,
  prepAndConvert ,
  convertAll ,
  convertAll2 ,
  soi ,
  string_of_feature ,
  string_of_direction ,
  string_of_meeting ,
  string_of_span_summaryi ,
  spanList_of_strokeList ,
  converter ,
  stringOfStrokeList ,
  drawingToDivider ,
  sof ,
  checkPanelhelper ,
  checkPanel ,
  panelLength ,
  pinHelper ,
  pinU ,
  pinL ,
  outerBox ,
  tabBoxes ,
  tabSlots ,
  slitL ,
  slitU ,
  stringOfBox ,
  dip ,
  allBoxesHelper ,
  allBoxes ,
  textOfPoint ,
  ps ,
  boxToPathD ,
  boxListToPathD ,
  boxListToPath ,
  text ,
  panelToPath ,
  dividerToSVG ,
  stringOfDivider ,
  
}
/* No side effect */
