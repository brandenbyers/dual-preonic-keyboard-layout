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
      console.log('Row number', rowNumber)
      layers[layer].rows[rowNumber].unshift(key)
    })
    // Define keyboard left and keyboard right
    let rows = layers[layer].rows
    console.log("rowy", rows)
    console.log("wozer", rows[0])
    layers[layer].leftKeyboard = [].concat(rows["0"], rows["1"], rows["2"], rows["3"], rows["4"])
    layers[layer].rightKeyboard = [].concat(rows["5"], rows["6"], rows["7"], rows["8"], rows["9"])
  }
}

const layerBlocks = collectLayers(dotFile)
collectKeys(layerBlocks)
separateKeyboards(layers)
console.log(layers)

// TODO: split keys by keyboard half
// TODO: separate keys into proper horizontally oriented keyboard rows
// TODO: write keys to QMK file
//
// If modulo unshift specific left/right keyboard and specific row 1-5
