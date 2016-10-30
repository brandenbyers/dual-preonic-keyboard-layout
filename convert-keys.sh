#!/usr/bin/env node

const fs = require('fs')
const args = require('minimist')(process.argv.slice(2))
const path = require('path')
const ent = require('ent')

const dotPath = args.dot
const dotFile = fs.readFileSync(dotPath, "utf8")

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
    console.log('Element:', key)
    if (key == " ") {
      return "_______"
      console.log("_______")
    } else {
      return key
    }
  })

  str = `[${layer}] = {
  {${k[0]},  ${k[1]},  ${k[2]},  ${k[3]},  ${k[4]},  ${k[5]},  ${k[6]},  ${k[7]},  ${k[8]},  ${k[9]},  ${k[10]},  ${k[11]}},
  {${k[12]},  ${k[13]},  ${k[14]},  ${k[15]},  ${k[16]},  ${k[17]},  ${k[18]},  ${k[19]},  ${k[20]},  ${k[21]},  ${k[22]},  ${k[23]}},
  {${k[24]},  ${k[25]},  ${k[26]},  ${k[27]},  ${k[28]},  ${k[29]},  ${k[30]},  ${k[31]},  ${k[32]},  ${k[33]},  ${k[34]},  ${k[35]}},
  {${k[36]},  ${k[37]},  ${k[38]},  ${k[39]},  ${k[40]},  ${k[41]},  ${k[42]},  ${k[43]},  ${k[44]},  ${k[45]},  ${k[46]}}, ${k[47]}},
  {${k[48]},  ${k[49]},  ${k[50]},  ${k[51]},  ${k[52]},  ${k[53]},  ${k[54]},  ${k[55]},  ${k[56]},  ${k[57]},  ${k[58]}}, ${k[59]}}
},`
  console.log(str)
}

const layerBlocks = collectLayers(dotFile)
collectKeys(layerBlocks)
separateKeyboards(layers)
console.log(layers)
keyboardToQMKString('_BASE_LEFT', layers.base.leftKeyboard)

// TODO: write keys to QMK file
//
// If modulo unshift specific left/right keyboard and specific row 1-5
