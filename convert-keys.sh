#!/usr/bin/env node

const fs = require('fs')
const args = require('minimist')(process.argv.slice(2))
const path = require('path')

const dotPath = args.dot
const dotFile = fs.readFileSync(dotPath, "utf8")

var layersAndKeys = {}

function collectLayers(dotFile) {
  const layers = dotFile.match(/\*\s\w+\sLAYER \*/gi)
  console.log(layers)
  let layerBlockIndexes = []
  let layerBlocks = []
  let layerName = ""
  if (layers) {
    layers.forEach(function(el) {
      layerBlockIndexes.push(dotFile.indexOf(el))
    })
    layerBlockIndexes.forEach(function(el, i) {
      layerName = layers[i].toString().match(/\*\s(\w+)\sLAYER \*/)[1]
      console.log(layerName)
      layersAndKeys[layerName] = {}
      if (i < layerBlockIndexes.length) {
        return layerBlocks.push([layerName, dotFile.substring(el, layerBlockIndexes[i + 1])])
      } else {
        return layerBlocks.push([layerName, dotFile.substring(el)])
      }
    })
    console.log("Indexes:", layerBlockIndexes)
    console.log(layersAndKeys)
  }
  return layerBlocks
}

function collectKeys(layerBlocks) {
  return layerBlocks.forEach(function(el, i) {
    layersAndKeys[el[0]].keys = el[1].match(/<td.+>(.+)<\/font><\/td>/gi)
    return layersAndKeys[el[0]].keys.forEach(function(el, i, arr) {
      // TODO: replace any HTML symbol codes
      // TODO: flag any modifiers that will require manual key decisions or figure out commenting system and grab comments instead key name visible in the pdf
      return arr[i] = el.match(/<td.+>(.+)<\/font><\/td>/i)[1]
    })
  })
}

const layerBlocks = collectLayers(dotFile)
collectKeys(layerBlocks)
console.log(layersAndKeys)

// TODO: split keys by keyboard half
// TODO: separate keys into proper horizontally oriented keyboard rows
// TODO: write keys to QMK file
