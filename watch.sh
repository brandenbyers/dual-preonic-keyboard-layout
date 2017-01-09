#!/bin/bash

echo watch $1.dot then "dot -Tpdf $1.dot -o $1.pdf"
watch $1.dot then "dot -Tpdf $1.dot -o $1.pdf"
