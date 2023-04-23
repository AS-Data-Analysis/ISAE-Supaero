from math import *
from vpython import *
scene=canvas(title="Satellites around a planet")
class Planet:
    def __init__(self,radius,position,col,node,mass=1):
        self.mass=mass
        self.node=node
        self.radius=radius
        self.pos=position
        self.color=col
        self.s=sphere(pos=position,radius=radius,color=col,make_trail=True)
        
M=5.98e24
R=10e6
G = 6.67e-11
POS=vector(0,0,0)
earth=Planet(R,POS,color.blue,"",M)

class Satellite(Planet):
    def __init__(self,speed,pos,planet,size,color,angle,axis,cangle,node):
        self.planet=planet
        self.pos=rotate(pos,angle=angle,axis=axis)
        self.speed=sqrt((G*self.planet.mass)/mag(self.planet.pos - self.pos))*norm(rotate(self.pos,angle=pi/2,axis=axis))
        self.size=size
        self.color=color
        self.cangle=cangle
        self.node=node
        
        self.s=sphere(pos=self.pos,radius=size,color=color,make_trail=True,retain=80)
        self.wing1 = box(pos=self.pos + 2e6*norm(self.pos),length=10e6,height=3e6,width=0,axis=norm(speed))
        self.wing2 = box(pos=self.pos - 2e6*norm(self.pos),length=10e6,height=3e6,width=0,axis=norm(speed))
        
        self.wing1.rotate(angle=angle,axis=axis,origin=vector(0,0,0))
        self.wing2.rotate(angle=angle,axis=axis,origin=vector(0,0,0))
        self.mycone = cone(pos=planet.pos,axis=self.pos - planet.pos,radius=mag(self.pos - planet.pos)*tan(self.cangle/2))
        
    def updatePosition(self,dt):
        rate(80)
        r = self.planet.pos - self.s.pos
        a = G * self.planet.mass * norm(r) / mag2(r)
        self.speed = self.speed + a*dt
        self.s.pos = self.s.pos + (self.speed)*dt

        self.wing1.pos = self.s.pos + 2e6*norm(self.s.pos)
        self.wing2.pos = self.s.pos - 2e6*norm(self.s.pos)
        self.mycone.pos = mag(self.mycone.pos)*norm(self.s.pos - self.planet.pos)

        self.wing1.axis -= a*dt
        self.wing2.axis -= a*dt
        self.mycone.axis = mag(self.mycone.axis)*norm(self.s.pos - self.planet.pos)

class Message:
    def __init__(self,received,text,nbHops):
        self.received=received
        self.text=text
        self.nbHops=nbHops
        
        

# X-Y Plane

sat1=Satellite(vector(1,0,0),vector(0,26e6,0),earth,1e6,color.white,0,vector(0,0,1),17*pi/180,"")
sat2=Satellite(vector(1,0,0),vector(0,26e6,0),earth,1e6,color.white,2*pi/3,vector(0,0,1),17*pi/180,"")
sat3=Satellite(vector(1,0,0),vector(0,26e6,0),earth,1e6,color.white,4*pi/3,vector(0,0,1),17*pi/180,"")

# Y-Z Plane

sat4=Satellite(vector(0,0,-1),vector(0,26e6,0),earth,1e6,color.white,0,vector(1,0,0),17*pi/180,"")
sat5=Satellite(vector(0,0,-1),vector(0,26e6,0),earth,1e6,color.yellow,2*pi/3,vector(1,0,0),17*pi/180,"")
sat6=Satellite(vector(0,0,-1),vector(0,26e6,0),earth,1e6,color.white,4*pi/3,vector(1,0,0),17*pi/180,"receiver")

# Plane1 in between the 2 above planes

#sat7=Satellite(vector(1,0,1),vector(0,26e6,0),earth,1e6,color.white,0,vector(1,0,-1),17*pi/180,"")
#sat8=Satellite(vector(1,0,1),vector(0,26e6,0),earth,1e6,color.white,2*pi/3,vector(1,0,-1),17*pi/180,"")
#sat9=Satellite(vector(1,0,1),vector(0,26e6,0),earth,1e6,color.white,4*pi/3,vector(1,0,-1),17*pi/180,"")

# Plane2 in between the 2 above planes

#sat10=Satellite(vector(-1,0,1),vector(0,26e6,0),earth,1e6,color.white,0,vector(1,0,1),17*pi/180,"")
#sat11=Satellite(vector(-1,0,1),vector(0,26e6,0),earth,1e6,color.white,2*pi/3,vector(1,0,1),17*pi/180,"")
#sat12=Satellite(vector(-1,0,1),vector(0,26e6,0),earth,1e6,color.white,4*pi/3,vector(1,0,1),17*pi/180,"receiver")

# Relays

north_relay = Planet(1e6,vector(0,R,0),color.white,"")
south_relay = Planet(1e6,vector(0,-R,0),color.white,"")
antenna = Planet(1e6,vector(0,0,R),color.white,"")

relays=[antenna,north_relay,south_relay]
sats=[sat1,sat2,sat3,sat4,sat5,sat6]

signal=Message(False,"",0)


while True:
    sat1.updatePosition(100)
    sat2.updatePosition(100)
    sat3.updatePosition(100)
    sat4.updatePosition(100)
    sat5.updatePosition(100)
    sat6.updatePosition(100)
    #sat7.updatePosition(100)
    #sat8.updatePosition(100)
    #sat9.updatePosition(100)
    #sat10.updatePosition(100)
    #sat11.updatePosition(100)
    #sat12.updatePosition(100)
    
    for i in relays:
        for j in sats:
            if diff_angle(i.pos,j.pos)<=25*pi/180:
                if i.s.color or j.s.color == color.yellow:
                    i.s.color = color.yellow
                    j.s.color = color.yellow
                    signal.nbHops += 1
                    if i.node or j.node == 'receiver':
                        signal.received = True
                        signal.text = f'Signal Received in {signal.nbHops} jumps'
                        print(signal.text)
                        break
    if signal.received:
        break