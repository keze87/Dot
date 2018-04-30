#!/bin/bash

pamixer --set-volume $(kdialog --slider "Volumen?" 0 100 1)
