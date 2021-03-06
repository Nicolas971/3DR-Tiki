 include("Nema.coffee")

class MotorMount extends Part
  constructor:(options)->
    @defaults = {
      width: 47
      height : 47
      thickness:8
      smoothRodMounts : true
      generateAtConstruct:true #special flag
      
      mntHolesLength : 7
      mntHolesDia: 3.5
      motor:null
      motorType:"Nema17"
    }
    options = @injectOptions(@defaults,options)
    super options
    
    if @generateAtConstruct
      @generate()
    
  generate:->
    mntHoleSLng = @mntHolesLength
    plate = new Cube({size:[@thickness,@width,@height],center:[true,true,false]})
    
    motor = new NemaMotor({generateAtConstruct:false})
    motor.pilotRing_radius = 15
    pilotRing = new Cylinder(
      {
        h: @thickness
        r: motor.pilotRing_radius
        center: [true, true, true]
      }).color([0.5, 0.5, 0.6])
    pilotRing.rotate([0,90,0]).translate([0,0,@height/2])
    
    @union plate
    @subtract( pilotRing )
    
    mountingholes = new Cylinder({
      h: @thickness*2
      d: @mntHolesDia
      center: [-@height/2, true, true ]
    })
    
    
    mntHolRad = @mntHolesDia/2#motor.mountingholes_radius
    mntHoleSOffs = mntHoleSLng/2 - mntHolRad
    mntHoleSStart = new Circle({r:mntHolRad,$fn:10,center:[mntHoleSOffs,0]})
    mntHoleSEnd = new Circle({r:mntHolRad,$fn:10,center:[-mntHoleSOffs,0]})

    mntHoleShape = hull([mntHoleSEnd, mntHoleSStart] )
    mntHoleShape = mntHoleShape.extrude({offset:[0,0,@thickness]})
    #@add mntHoleShape
    
    mntHoleCenterOffset = motor.mountingholes_fromcent
    mountingholes.rotate([0,90,0])
    for i in [-1,1]
      for j in [-1,1]
        tmpShape = mntHoleShape.clone()
        tmpShape.rotate([0,90,0])
        tmpShape.rotate([45*j*-i,0,0])
        tmpShape.translate([-@thickness/2,0,@height/2])
        
        tmpShape.translate([0,mntHoleCenterOffset*i,mntHoleCenterOffset*j])

        @subtract tmpShape.color([1,0,0])
        