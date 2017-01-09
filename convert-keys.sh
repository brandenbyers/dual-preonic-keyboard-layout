#!/usr/bin/env node

const fs = require('fs')
const args = require('minimist')(process.argv.slice(2))
const path = require('path')
const ent = require('ent')

const dotPath = args.dot
const dotFile = fs.readFileSync(dotPath, "utf8")
const keycodes = {
  // Special
  RESET: "RESET",                  // Reset
  KC_TRNS: "_______",              // Transparent
  ctrlE: "CTL_T(KC_ESC)",          // Escape on Tap and Control on hold
  shiftZ: "SFT_T(KC_Z)",           // Z on Tap and Shift on hold
  shiftS: "SFT_T(KC_SLSH)",        // Slash on Tap and Shift on hold
  optC: "ALT_T(KC_C)",             // C on Tap and Option on hold
  "opt,": "ALT_T(KC_COMM)",        // Slash on Tap and Option on hold
  cmdV: "GUI_T(KC_V)",             // V on Tap and Command on hold
  cmdM: "GUI_T(KC_M)",             // M on Tap and Command on hold
  hyperT: "ALL_T(KC_TAB)",         // Tab on Tap and Hyper on hold
  leader: "KC_LEAD",               // Leader Key
  base: "TO(_BASE)",               // Go To Base Layer
  mouse: "TG(_MOUSE)",             // Toggle Mouse Layer
  code: "OSL(_CODE)",               // Momentary Switch to Code Layer when held
  vim: "OSL(_VIM)",                 // Momentary Switch Vim Layer
  macro: "OSL(_MACRO)",            // One-Shot Momentary Switch to Macro Layer
  no: "KC_NO",                     // 00 Reserved (no event indicated)
  rollover: "KC_ROLL_OVER",        // 01 Keyboard ErrorRollOver
  fail: "KC_POST_FAIL",            // 02 Keyboard POSTFail
  err: "KC_UNDEFINED",             // 03 Keyboard Error Undefined
  // Shifted Keys
  "~": "LSFT(KC_GRV)",
  "!": "LSFT(KC_1)",
  "@": "LSFT(KC_2)",
  "#": "LSFT(KC_3)",
  "$": "LSFT(KC_4)",
  "%": "LSFT(KC_5)",
  "^": "LSFT(KC_6)",
  "&": "LSFT(KC_7)",
  "*": "LSFT(KC_8)",
  "(": "LSFT(KC_9)",
  ")": "LSFT(KC_0)",
  "_": "LSFT(KC_MINS)",
  "+": "LSFT(KC_EQL)",
  "{": "LSFT(KC_LBRC)",
  "}": "LSFT(KC_RBRC)",
  "|": "LSFT(KC_BSLS)",
  ":": "LSFT(KC_SCLN)",
  "\"": "LSFT(KC_QUOT)",
  "<": "LSFT(KC_COMM)",
  ">": "LSFT(KC_DOT)",
  "?": "LSFT(KC_SLSH)",
  // Option Shift Keys
  "°": "LALT(LSFT(KC_8))",         // Degrees Symbol
  "¨": "LALT(LSFT(KC_U))",         // Umlaut ¨
  // Regular Keys
  a: "KC_A",                       // 04 Keyboard a and A
  b: "KC_B",                       // 05 Keyboard b and B
  c: "KC_C",                       // 06 Keyboard c and C
  d: "KC_D",                       // 07 Keyboard d and D
  e: "KC_E",                       // 08 Keyboard e and E
  f: "KC_F",                       // 09 Keyboard f and F
  g: "KC_G",                       // 0A Keyboard g and G
  h: "KC_H",                       // 0B Keyboard h and H
  i: "KC_I",                       // 0C Keyboard i and I
  j: "KC_J",                       // 0D Keyboard j and J
  k: "KC_K",                       // 0E Keyboard k and K
  l: "KC_L",                       // 0F Keyboard l and L
  m: "KC_M",                       // 10 Keyboard m and M
  n: "KC_N",                       // 11 Keyboard n and N
  o: "KC_O",                       // 12 Keyboard o and O
  p: "KC_P",                       // 13 Keyboard p and P
  q: "KC_Q",                       // 14 Keyboard q and Q
  r: "KC_R",                       // 15 Keyboard r and R
  s: "KC_S",                       // 16 Keyboard s and S
  t: "KC_T",                       // 17 Keyboard t and T
  u: "KC_U",                       // 18 Keyboard u and U
  v: "KC_V",                       // 19 Keyboard v and V
  w: "KC_W",                       // 1A Keyboard w and W
  x: "KC_X",                       // 1B Keyboard x and X
  y: "KC_Y",                       // 1C Keyboard y and Y
  z: "KC_Z",                       // 1D Keyboard z and Z
  "1": "KC_1",                     // 1E Keyboard 1 and !
  "2": "KC_2",                     // 1F Keyboard 2 and @
  "3": "KC_3",                     // 20 Keyboard 3 and #
  "4": "KC_4",                     // 21 Keyboard 4 and $
  "5": "KC_5",                     // 22 Keyboard 5 and %
  "6": "KC_6",                     // 23 Keyboard 6 and ^
  "7": "KC_7",                     // 24 Keyboard 7 and &
  "8": "KC_8",                     // 25 Keyboard 8 and *
  "9": "KC_9",                     // 26 Keyboard 9 and (
  "0": "KC_0",                     // 27 Keyboard 0 and )
  "return": "KC_ENT",         // 28 Keyboard Return (ENTER)
  esc: "KC_ESC",            // 29 Keyboard ESCAPE
  bksp: "KC_BSPC",          // 2A Keyboard DELETE (Backspace)
  tab: "KC_TAB",            // 2B Keyboard Tab
  space: "KC_SPC",          // 2C Keyboard Spacebar
  "-": "KC_MINS",           // 2D Keyboard - and (underscore)
  "=": "KC_EQL",            // 2E Keyboard = and +
  "[": "KC_LBRC",           // 2F Keyboard [ and {
  "]": "KC_RBRC",           // 30 Keyboard ] and }
  "\\": "KC_BSLS",        // 31 Keyboard \ and |
  nuhs: "KC_NUHS",        // 32 Keyboard Non-US # and ~
  ";": "KC_SCLN",        // 33 Keyboard ; and :
  "'": "KC_QUOT",        // 34 Keyboard ‘ and “
  "`": "KC_GRV",         // 35 Keyboard Grave Accent and Tilde
  ",": "KC_COMM",        // 36 Keyboard , and <
  ".": "KC_DOT",         // 37 Keyboard . and >
  "/": "KC_SLSH",        // 38 Keyboard / and ?
  "caps": "KC_CAPS",        // 39 Keyboard Caps Lock
  "F1": "KC_F1",          // 3A Keyboard F1
  "F2": "KC_F2",          // 3B Keyboard F2
  "F3": "KC_F3",          // 3C Keyboard F3 "F4": "KC_F4",          // 3D Keyboard F4
  "F5": "KC_F5",          // 3E Keyboard F5
  "F6": "KC_F6",          // 3F Keyboard F6
  "F7": "KC_F7",          // 40 Keyboard F7
  "F8": "KC_F8",          // 41 Keyboard F8
  "F9": "KC_F9",          // 42 Keyboard F9
  "F10": "KC_F10",         // 43 Keyboard F10
  "F11": "KC_F11",         // 44 Keyboard F11
  "F12": "KC_F12",         // 45 Keyboard F12
  "pscr": "KC_PSCR",        // 46 Keyboard PrintScreen1
  "slck": "KC_SLCK",        // 47 Keyboard Scroll Lock11
  "pause": "KC_PAUS",        // 48 Keyboard Pause1
  "insert": "KC_INS",         // 49 Keyboard Insert
  "home": "KC_HOME",        // 4A Keyboard Home
  "pgup": "KC_PGUP",        // 4B Keyboard PageUp
  "del": "KC_DELETE",      // 4C Keyboard Delete Forward
  "end": "KC_END",         // 4D Keyboard End1
  "pgdn": "KC_PGDN",        // 4E Keyboard PageDown1
  "→": "KC_RGHT",        // 4F Keyboard RightArrow1
  "←": "KC_LEFT",        // 50 Keyboard LeftArrow1
  "↓": "KC_DOWN",        // 51 Keyboard DownArrow1
  "↑": "KC_UP",          // 52 Keyboard UpArrow1
  "nlck": "KC_NLCK",        // 53 Keypad Num Lock and Clear11
  "n/": "KC_PSLS",        // 54 Keypad /
  "n*": "KC_PAST",        // 55 Keypad *
  "n-": "KC_PMNS",        // 56 Keypad -
  "n+": "KC_PPLS",        // 57 Keypad +
  "enter": "KC_PENT",        // 58 Keypad ENTER
  "n1": "KC_P1",          // 59 Keypad 1 and End
  "n2": "KC_P2",          // 5A Keypad 2 and Down Arrow
  "n3": "KC_P3",          // 5B Keypad 3 and PageDn
  "n4": "KC_P4",          // 5C Keypad 4 and Left Arrow
  "n5": "KC_P5",          // 5D Keypad 5
  "n6": "KC_P6",          // 5E Keypad 6 and Right Arrow
  "n7": "KC_P7",          // 5F Keypad 7 and Home
  "n8": "KC_P8",          // 60 Keypad 8 and Up Arrow
  "n9": "KC_P9",          // 61 Keypad 9 and PageUp
  "n0": "KC_P0",          // 62 Keypad 0 and Insert
  "n.": "KC_PDOT",        // 63 Keypad . and Delete
  "n=": "KC_PEQL",        // 67 Keypad =
  "n,": "KC_PCMM",           // 85 Keypad Comma
  "n==": "KC_KP_EQUAL_AS400", // 86 Keypad Equal Sign
  "nubs": "KC_NUBS",        // 64 Keyboard Non-US \ and |
  "app": "KC_APP",         // 65 Keyboard Application
  "kpower": "KC_POWER",       // 66 Keyboard Power
  // "": "KC_F13",         // 68 Keyboard F13
  // "": "KC_F14",         // 69 Keyboard F14
  // "": "KC_F15",         // 6A Keyboard F15
  // "": "KC_F16",         // 6B Keyboard F16
  // "": "KC_F17",         // 6C Keyboard F17
  // "": "KC_F18",         // 6D Keyboard F18
  // "": "KC_F19",         // 6E Keyboard F19
  // "": "KC_F20",         // 6F Keyboard F20
  // "": "KC_F21",         // 70 Keyboard F21
  // "": "KC_F22",         // 71 Keyboard F22
  // "": "KC_F23",         // 72 Keyboard F23
  // "": "KC_F24",         // 73 Keyboard F24
  "execute": "KC_EXECUTE",     // 74 Keyboard Execute
  "help": "KC_HELP",        // 75 Keyboard Help
  "menu": "KC_MENU",        // 76 Keyboard Menu
  "select": "KC_SELECT",      // 77 Keyboard Select
  "kstop": "KC_STOP",        // 78 Keyboard Stop
  "again": "KC_AGAIN",       // 79 Keyboard Again
  "undo": "KC_UNDO",        // 7A Keyboard Undo
  "cut": "KC_CUT",         // 7B Keyboard Cut
  "copy": "KC_COPY",        // 7C Keyboard Copy
  "paste": "KC_PASTE",       // 7D Keyboard Paste
  "find": "KC_FIND",        // 7E Keyboard Find
  "kmute": "KC__MUTE",       // 7F Keyboard Mute
  "kvolup": "KC__VOLUP",      // 80 Keyboard Volume Up
  "kvoldown": "KC__VOLDOWN",    // 81 Keyboard Volume Down
  "lockcaps": "KC_LOCKING_CAPS", // 82 Keyboard Locking Caps Lock
  "locknum": "KC_LOCKING_NUM",   // 83 Keyboard Locking Num Lock
  "lockscroll": "KC_LOCKING_SCROLL", // 84 Keyboard Locking Scroll Lock
  "ro": "KC_RO",          // 87 Keyboard International115
  "kana": "KC_KANA",        // 88 Keyboard International216
  "jyen": "KC_JYEN",        // 89 Keyboard International317
  "henk": "KC_HENK",        // 8A Keyboard International418
  "mhen": "KC_MHEN",        // 8B Keyboard International519
  "int6": "KC_INT6",        // 8C Keyboard International620
  "int7": "KC_INT7",        // 8D Keyboard International721
  "int8": "KC_INT8",        // 8E Keyboard International822
  "int9": "KC_INT9",        // 8F Keyboard International922
  "lang1": "KC_LANG1",       // 90 Keyboard LANG125
  "lang2": "KC_LANG2",       // 91 Keyboard LANG226
  "lang3": "KC_LANG3",       // 92 Keyboard LANG330
  "lang4": "KC_LANG4",       // 93 Keyboard LANG431
  "lang5": "KC_LANG5",       // 94 Keyboard LANG532
  "lang6": "KC_LANG6",       // 95 Keyboard LANG68
  "lang7": "KC_LANG7",       // 96 Keyboard LANG78
  "lang8": "KC_LANG8",       // 97 Keyboard LANG88
  "lang9": "KC_LANG9",       // 98 Keyboard LANG98
  "erase": "KC_ALT_ERASE",   // 99 Keyboard Alternate Erase7
  "sysreq": "KC_SYSREQ",      // 9A Keyboard SysReq/Attention1
  "cancel": "KC_CANCEL",      // 9B Keyboard Cancel
  "clear": "KC_CLEAR",       // 9C Keyboard Clear
  "prior": "KC_PRIOR",       // 9D Keyboard Prior
  "return return": "KC_RETURN",      // 9E Keyboard Return
  "separator": "KC_SEPARATOR",   // 9F Keyboard Separator
  "out": "KC_OUT",         // A0 Keyboard Out
  "oper": "KC_OPER",        // A1 Keyboard Oper
  "clear again": "KC_CLEAR_AGAIN", // A2 Keyboard Clear/Again
  "crsel": "KC_CRSEL",       // A3 Keyboard CrSel/Props
  "exsel": "KC_EXSEL",       // A4 Keyboard ExSel
// #<{(| Modifiers |)}>#
  "ctrl": "KC_LCTL",        // E0 Keyboard LeftControl
  "shift": "KC_LSFT",        // E1 Keyboard LeftShift
  "opt": "KC_LALT",        // E2 Keyboard LeftAlt
  "cmd": "KC_LGUI",        // E3 Keyboard Left GUI(Windows/Apple/Meta key)
  "rctrl": "KC_RCTL",        // E4 Keyboard RightControl
  "rshift": "KC_RSFT",        // E5 Keyboard RightShift
  "rightopt": "KC_RALT",        // E6 Keyboard RightAlt
  "rcmd": "KC_RGUI",        // E7 Keyboard Right GUI(Windows/Apple/Meta key)
// #<{(| System Control |)}>#
  "power": "KC_PWR",         // System Power Down
  "sleep": "KC_SLEP",        // System Sleep
  "wake": "KC_WAKE",        // System Wake
// #<{(| Consumer Page |)}>#
  "mute": "KC_MUTE",  // KC_AUDIO_MUTE
  "volu": "KC_VOLU",  // KC_AUDIO_VOL_UP
  "vold": "KC_VOLD",  // KC_AUDIO_VOL_DOWN
  "next": "KC_MNXT",  // KC_MEDIA_NEXT_TRACK
  "prev": "KC_MPRV",  // KC_MEDIA_PREV_TRACK
  "stop": "KC_MSTP",  // KC_MEDIA_STOP
  "play": "KC_MPLY",  // KC_MEDIA_PLAY_PAUSE
  "mediaselect": "KC_MSEL",  // KC_MEDIA_SELECT
  "mail": "KC_MAIL",
  "calc": "KC_CALC",  // KC_CALCULATOR
  "mycm": "KC_MYCM",  // KC_MY_COMPUTER
  "wwwsearch": "KC_WSCH",  // KC_WWW_SEARCH
  "wwwhome": "KC_WHOM",  // KC_WWW_HOME
  "wwwback": "KC_WBAK",  // KC_WWW_BACK
  "wwwforward": "KC_WFWD",  // KC_WWW_FORWARD
  "wwwstop": "KC_WSTP",  // KC_WWW_STOP
  "wwwrefresh": "KC_WREF",  // KC_WWW_REFRESH
  "wwwfavorites": "KC_WFAV",  // KC_WWW_FAVORITES
// #<{(| Mousekey |)}>#
  "mup": "KC_MS_U",     // Mouse Cursor Up
  "mdown": "KC_MS_D",     // Mouse Cursor Down
  "mleft": "KC_MS_L",     // Mouse Cursor Left
  "mright": "KC_MS_R",     // Mouse Cursor Right
  "lclick": "KC_BTN1",     // Mouse Button 1
  "rclick": "KC_BTN2",     // Mouse Button 2
  "btn3": "KC_BTN3",     // Mouse Button 3
  "btn4": "KC_BTN4",     // Mouse Button 4
  "btn5": "KC_BTN5",     // Mouse Button 5
  "sup": "KC_WH_U",     // Mouse Wheel Up
  "sdown": "KC_WH_D",     // Mouse Wheel Down
  "sleft": "KC_WH_L",     // Mouse Wheel Left
  "sright": "KC_WH_R",     // Mouse Wheel Right
  "acc0": "KC_ACL0",     // Mouse Acceleration 0
  "acc1": "KC_ACL1",     // Mouse Acceleration 1
  "acc2": "KC_ACL2",     // Mouse Acceleration 2
// #<{(| Fn key |)}>#
  "FN0": "KC_FN0",
  "FN1": "KC_FN1",
  "FN2": "KC_FN2",
  "FN3": "KC_FN3",
  "FN4": "KC_FN4",
  "FN5": "KC_FN5",
  "FN6": "KC_FN6",
  "FN7": "KC_FN7",
  "FN8": "KC_FN8",
  "FN9": "KC_FN9",
  "FN10": "KC_FN10",
  "FN11": "KC_FN11",
  "FN12": "KC_FN12",
  "FN13": "KC_FN13",
  "FN14": "KC_FN14",
  "FN15": "KC_FN15",
  "FN16": "KC_FN16",
  "FN17": "KC_FN17",
  "FN18": "KC_FN18",
  "FN19": "KC_FN19",
  "FN20": "KC_FN20",
  "FN21": "KC_FN21",
  "FN22": "KC_FN22",
  "FN23": "KC_FN23",
  "FN24": "KC_FN24",
  "FN25": "KC_FN25",
  "FN26": "KC_FN26",
  "FN27": "KC_FN27",
  "FN28": "KC_FN28",
  "FN29": "KC_FN29",
  "FN30": "KC_FN30",
  "FN31": "KC_FN31"
}

var layers = {}


function collectLayers(dotFile) {
  const layerMatches = dotFile.match(/\*\s\w+\sLAYER \*/gi)
  console.log(layerMatches)
  let layerBlockIndexes = []
  let layerBlocks = []
  let layerName = ""
  if (layerMatches) {
    layerMatches.forEach(function(el) {
      layerBlockIndexes.push(dotFile.indexOf(el))
    })
    layerBlockIndexes.forEach(function(el, i) {
      layerName = layerMatches[i].toString().match(/\*\s(\w+)\sLAYER \*/)[1].toLowerCase()
      console.log(layerName)
      layers[layerName] = {}
      if (i < layerBlockIndexes.length) {
        return layerBlocks.push([layerName, dotFile.substring(el, layerBlockIndexes[i + 1])])
      } else {
        return layerBlocks.push([layerName, dotFile.substring(el)])
      }
    })
    console.log("Indexes:", layerBlockIndexes)
    console.log(layers)
  }
  return layerBlocks
}

function collectKeys(layerBlocks) {
  return layerBlocks.forEach(function(el, i) {
    layers[el[0]].keys = el[1].match(/<td.+>(.+)<\/font><\/td>/gi)
    return layers[el[0]].keys.forEach(function(el, i, arr) {
      // TODO: flag any modifiers that will require manual key decisions or figure out commenting system and grab comments instead key name visible in the pdf
      return arr[i] = ent.decode(el.match(/<td.+>(.+)<\/font><\/td>/i)[1])
    })
  })
}

function separateKeyboards(layers) {
  if (!layers) {
    return console.log("Can not separate rows without layers and keys.")
  }
  for (let layer in layers) {
    // Define row arrays
    layers[layer].rows = {}
    for (let rowNumber of [0,1,2,3,4,5,6,7,8,9]){
      layers[layer].rows[rowNumber] = []
    }
    // Split vertical keyboard into horizontal rows
    layers[layer].keys.forEach(function(key, i) {
      let rowNumber = i % 10
      layers[layer].rows[rowNumber].unshift(key)
    })
    // Define keyboard left and keyboard right
    let rows = layers[layer].rows
    layers[layer].leftKeyboard = [].concat(rows["0"], rows["1"], rows["2"], rows["3"], rows["4"])
    layers[layer].rightKeyboard = [].concat(rows["5"], rows["6"], rows["7"], rows["8"], rows["9"])
  }
}

function keyboardToQMKString(layer, keyboard) {
  // TODO: Dynamic tab generation
  let k = keyboard.map(function(key) {
    if (key == ent.decode("&nbsp;")) {
      return "KC_TRNS"
    } else {
      return key
    }
  })

  str = `[${layer}] = {
  {${keycodes[k[0]]},  ${keycodes[k[1]]},  ${keycodes[k[2]]},  ${keycodes[k[3]]},  ${keycodes[k[4]]},  ${keycodes[k[5]]},  ${keycodes[k[6]]},  ${keycodes[k[7]]},  ${keycodes[k[8]]},  ${keycodes[k[9]]}},
  {${keycodes[k[10]]},  ${keycodes[k[11]]},  ${keycodes[k[12]]},  ${keycodes[k[13]]},  ${keycodes[k[14]]},  ${keycodes[k[15]]},  ${keycodes[k[16]]},  ${keycodes[k[17]]},  ${keycodes[k[18]]},  ${keycodes[k[19]]}},
  {${keycodes[k[20]]},  ${keycodes[k[21]]},  ${keycodes[k[22]]},  ${keycodes[k[23]]},  ${keycodes[k[24]]},  ${keycodes[k[25]]},  ${keycodes[k[26]]},  ${keycodes[k[27]]},  ${keycodes[k[28]]},  ${keycodes[k[29]]}},
  {${keycodes[k[30]]},  ${keycodes[k[31]]},  ${keycodes[k[32]]},  ${keycodes[k[33]]},  ${keycodes[k[34]]},  ${keycodes[k[35]]},  ${keycodes[k[36]]},  ${keycodes[k[37]]},  ${keycodes[k[38]]},  ${keycodes[k[39]]}},
  {${keycodes[k[40]]},  ${keycodes[k[41]]},  ${keycodes[k[42]]},  ${keycodes[k[43]]},  ${keycodes[k[44]]},  ${keycodes[k[45]]},  ${keycodes[k[46]]},  ${keycodes[k[47]]},  ${keycodes[k[48]]},  ${keycodes[k[49]]}}
},`
  console.log(str)
}

const layerBlocks = collectLayers(dotFile)
collectKeys(layerBlocks)
// separateKeyboards(layers)
console.log(layers)
// keyboardToQMKString('_BASE_LEFT', layers.base.leftKeyboard)
keyboardToQMKString('_BASE', layers.base.keys)
keyboardToQMKString('_MOUSE', layers.mouse.keys)
keyboardToQMKString('_CODE', layers.code.keys)
keyboardToQMKString('_VIM', layers.vim.keys)
keyboardToQMKString('_MACRO', layers.macro.keys)

// TODO: write keys to QMK file
//
// If modulo unshift specific left/right keyboard and specific row 1-5


/* BASE
 * ┏━━━━━━┳━━━━━━┳━━━━━━┳━━━━━━┳━━━━━━┳━━━━━━┓ ┏━━━━━━┳━━━━━━┳━━━━━━┳━━━━━━┳━━━━━━┳━━━━━━┓
 * ┃ ctrl ┃      ┃      ┃      ┃      ┃      ┃ ┃ ctrl ┃      ┃      ┃      ┃      ┃      ┃
 * ┣━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━┫ ┣━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━┫
 * ┃      ┃      ┃      ┃      ┃      ┃      ┃ ┃      ┃      ┃      ┃      ┃      ┃      ┃
 * ┣━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━┫ ┣━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━┫
 * ┃      ┃      ┃      ┃      ┃      ┃      ┃ ┃      ┃      ┃      ┃      ┃      ┃      ┃
 * ┣━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━┫ ┣━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━┫
 * ┃      ┃      ┃      ┃      ┃      ┃      ┃ ┃      ┃      ┃      ┃      ┃      ┃      ┃
 * ┣━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━┫ ┣━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━┫
 * ┃      ┃      ┃      ┃      ┃      ┃      ┃ ┃      ┃      ┃      ┃      ┃      ┃      ┃
 * ┣━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━┫ ┣━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━╋━━━━━━┫
 * ┃      ┃      ┃      ┃      ┃      ┃      ┃ ┃      ┃      ┃      ┃      ┃      ┃      ┃
 * ┗━━━━━━┻━━━━━━┻━━━━━━┻━━━━━━┻━━━━━━┻━━━━━━┛ ┗━━━━━━┻━━━━━━┻━━━━━━┻━━━━━━┻━━━━━━┻━━━━━━┛
 */
