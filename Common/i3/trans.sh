#!/bin/sh

VALUE=$(zenity --scale --text="Cuan opaco?" --value=100)

compton-trans "${VALUE}"%
