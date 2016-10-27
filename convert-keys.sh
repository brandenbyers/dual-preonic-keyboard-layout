#!/usr/bin/env node

const fs = require('fs')
const args = require('minimist')(process.argv.slice(2))
const path = require('path')

const dotFile = args.dotFile

function collectLayers(dotFile) {

}

// var collectSteps, collectTestCases;
//
// collectTestCases = function(suite) {
//   var itBlockDeclarations, itBlockIndexes, itBlocks, rawTestCaseName, testCaseId, testCaseIds, testCaseName, testCasePriority, testCaseVersion, testCases;
//   itBlockDeclarations = suites[suite].contents.match(/it '.*\[TC\d+\.\d+\].*'/gi);
//   itBlockIndexes = [];
//   itBlocks = [];
//   testCaseId = [];
//   rawTestCaseName = '';
//   testCaseName = '';
//   testCaseVersion = 0;
//   testCasePriority = 1;
//   testCaseIds = [];
//   testCases = {};
//   if (itBlockDeclarations) {
//     itBlockDeclarations.forEach(function(el) {
//       itBlockIndexes.push(suites[suite].contents.indexOf(el));
//       return totalTestCases++;
//     });
//     itBlockIndexes.forEach(function(el, i) {
//       testCaseId = itBlockDeclarations[i].toString().match(/\[TC(\d+)\.\d+\]/)[1];
//       testCaseVersion = itBlockDeclarations[i].toString().match(/\[TC\d+\.(\d+)\]/)[1];
//       rawTestCaseName = itBlockDeclarations[i].toString().match(/.*\[TC\d+\.\d+\]\s(.*)'/)[1];
//       testCaseName = rawTestCaseName.charAt(0).toUpperCase() + rawTestCaseName.slice(1);
//       if (itBlockDeclarations[i].toString().match(/.*'P(.):\s\[TC\d+\.\d+\]\s.|)}>#)) {
//         testCasePriority = parseInt(itBlockDeclarations[i].toString().match(/.*'P(.):\s\[TC\d+\.\d+\]\s.|)}>#)[1]);
//       }
//       testCaseIds.push([testCaseId, testCaseName, testCasePriority, testCaseVersion]);
//       if (i < itBlockIndexes.length) {
//         return itBlocks.push(suites[suite].contents.substring(el, itBlockIndexes[i + 1]));
//       } else {
//         return itBlocks.push(suites[suite].contents.substring(el));
//       }
//     });
//     collectSteps(itBlocks, testCases, testCaseIds, testCasePriority, suite);
//   }
//   return testCases;
// };
//
// collectSteps = function(itBlocks, testCases, testCaseIds, testCasePriority, suite) {
//   return itBlocks.forEach(function(el, i) {
//     if (testCaseIds[i][0]) {
//       testCases[testCaseIds[i][0]] = {};
//       testCases[testCaseIds[i][0]].name = testCaseIds[i][1];
//       testCases[testCaseIds[i][0]].number = testCaseIds[i][0];
//       testCases[testCaseIds[i][0]].version = testCaseIds[i][3];
//       testCases[testCaseIds[i][0]].suite = suite;
//       if (/## Description:.|)}>#gi.exec(el)) {
//         testCases[testCaseIds[i][0]].description = /## Description:.|)}>#i.exec(el)[0].replace('## Description: ', '');
//       } else {
//         console.log('WARNING: no description for test case'.red, testCaseIds[i][0]);
//       }
//       if (/## Assumption:.|)}>#i.exec(el)) {
//         testCases[testCaseIds[i][0]].assumption = /## Assumption:.|)}>#i.exec(el)[0].replace('## Assumption: ', '');
//       } else {
//         console.log('WARNING: no assumption for test case'.red, testCaseIds[i][0]);
//       }
//       if (testCasePriority[i]) {
//         testCases[testCaseIds[i][0]].priority = testCasePriority[i];
//       } else {
//         testCases[testCaseIds[i][0]].priority = 1;
//       }
//       testCases[testCaseIds[i][0]].steps = el.match(/##.(?!Description|Assumption).|)}>#gi);
//       return testCases[testCaseIds[i][0]].steps.forEach(function(el, i, arr) {
//         return arr[i] = arr[i].replace('## ', '').split(/;\s|;/);
//       });
//     }
//   });
// };
