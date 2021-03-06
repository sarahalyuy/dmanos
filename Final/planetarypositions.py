# -*- coding: utf-8 -*-
"""
Created on Tue Mar 31 20:16:34 2020

@author: danie
"""

# import packages
import ephem as e # this package is useful in astronomical calculations
import matplotlib.pyplot as mp

# create an object for each planet
me = e.Mercury();
v = e.Venus();
ma = e.Mars();
j = e.Jupiter();
s = e.Saturn();
u = e.Uranus();
n = e.Neptune();
p = e.Pluto();

# write a function that takes inputs of planet and date (as a string of 
# format 'yyyy/mm/dd') and returns a graph of the planet's position relative 
# to the Earth, which is located at the origin
def position(pl,date):
    # position is returned in terms of right ascension (hours of arc around
    # celestial equator) and declination (degrees north of celestial equator)
    pl.compute(date);
    
    # return the value of right ascension in degrees (declination can be 
    # ignored because it is not necessary for 2D plotting) and convert to
    # radians
    deg = e.hours(pl.g_ra);
    rad = repr(deg);
    
    # return the value of distance to Earth in km
    dist = pl.earth_distance;
    
    # convert angle and distance to polar coordinates
    r = dist;
    theta = rad;
    
    # graph result
    graph = mp.polar(theta,r);
    return graph