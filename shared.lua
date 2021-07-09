AddCSLuaFile()

SWEP.HoldType              	= "physgun"

if CLIENT then
   SWEP.PrintName          	= "Soviet Carbine"
   SWEP.Slot               	= 2

   SWEP.ViewModelFlip      	= false
   SWEP.ViewModelFOV       	= 72
   
   SWEP.DrawCrosshair		= true;
   SWEP.DrawAmmo			= false
   SWEP.SwayScale				= 0
   SWEP.BobScale 				= 0
end

SWEP.Base                  	= "weapon_base"
SWEP.Kind                  	= WEAPON_HEAVY
SWEP.WeaponID              	= AMMO_M16
--SWEP.IronSightsPos 			= Vector( -3.680, -12.2687, 6.88 )
--SWEP.IronSightsAng 			= Vector( -4.8723, -2.10, -2.5 )

SWEP.IronSightsPos 			= Vector(0,0,0 )
SWEP.IronSightsAng 			= Vector( 0,0,0)

SWEP.RecoilReductionSpeed 	= .05
SWEP.AutoSpawnable         	= true
SWEP.Spawnable             	= true
SWEP.AmmoEnt               	= "item_ammo_pistol_ttt"
SWEP.UseHands              	= true
SWEP.ViewModel             	= "models/weapons/soviet_carbine/soviet_carbine.mdl"
SWEP.WorldModel            	= "models/weapons/soviet_carbine/w_soviet_carbine.mdl"
SWEP.Spread					= .074
SWEP.MaxSpread				= .20
SWEP.SpreadReductionSpeed	= 0.01
SWEP.Zoom					= 30
SWEP.ADSSpeed				= .3
SWEP.EyeRotateMax			= 5
SWEP.SprayIndex 			= 1;
SWEP.SprayReductionSpeed 	= 0.5;
SWEP.DebugDamage 			= 0;
SWEP.DebugShotDistance 		= 0;
SWEP.CurrIronSightPos 		= Vector(0,0,0);
SWEP.CurrEyeRot 			= 0;
SWEP.isIronsights 			= false;

SWEP.Debug 					= true;

SWEP.Primary.Delay         	= .1
SWEP.Primary.LRecoil        = 1
SWEP.Primary.RRecoil        = 1
SWEP.Primary.URecoil        = 1
SWEP.Primary.DRecoil        = 0
SWEP.Primary.Automatic     	= true
SWEP.Primary.Ammo          	= "Pistol"
SWEP.Primary.Damage        	= 23
SWEP.Primary.Cone          	= 0.1
SWEP.Primary.ClipSize      	= 30
SWEP.Primary.ClipMax      	= 999999
SWEP.Primary.DefaultClip   	= 999999
SWEP.Primary.Sound         	= Sound( "Weapon_M4A1.Single" )
SWEP.Primary.FalloffMin		= 1000
SWEP.Primary.FalloffMax		= 2000
SWEP.Primary.Falloffscale	= .8
SWEP.Primary.Ricochets		= 5
SWEP.Primary.Penetration    = 100
SWEP.Primary.NumBullets		= 1
SWEP.Primary.Force			= 10
SWEP.Primary.Tracer			= 1

SWEP.Secondary.Automatic	= false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"

currMov = 1;

SWEP.DrawTrace = {};

--Weapon Handling Vars
SWEP.LerpRatio = 1;
SWEP.LerpAccel = 1.1;
SWEP.CurrViewPunch = Angle(0,0,0)
SWEP.ViewPunchResetTime = 0
SWEP.ViewPunchResetDelay = 0.125

SWEP.HideName = false;

SWEP.Spray = {
	[1] = {0, 8},
	[2] = {2, 10},
	[3] = {5, 15},
	[4] = {10, 8},
	[5] = {5, 8},
	[6] = {-5, 5},
	[7] = {-10, 10},
	[8] = {-12, 2.5},
	[9] = {-5, 5},
	[10] = {5, 1},
	[11] = {8, 0.5},
	[12] = {10, 1},
	[13] = {5, 1},
	[14] = {5, 1},
	[15] = {-1, 1},
	[16] = {-8, 1.5},
	[17] = {-10, 1},
	[18] = {-10, 1},
	[19] = {-8, 1},
	[20] = {-6,1}
}

function SWEP:Initialize()
	self:SetHoldType("ar2")
end

function SWEP:DrawCustomHUD()
	hook.Add( "HUDPaint", "drawammo", function() 
		if CLIENT then
			local ammoCount = "";
			local missingAmmo = "";
			local boxWidth = 0;
			local boxHeight = 60;
			local ammoTotalWidth = 22;

			for i=1, self:Clip1() do
				ammoCount = ammoCount .. "|"
			end

			for i=1, self:GetMaxClip1()-self:Clip1() do
				missingAmmo = missingAmmo .. "|"
			end

			surface.SetFont("DebugFont");
			local spareAmmoWidth = surface.GetTextSize(self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType()))
			local nameWidth = surface.GetTextSize(self.PrintName)

			ammoTotalWidth = ammoTotalWidth + surface.GetTextSize(self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType()))

			surface.SetFont("Ammo");
			local currAmmoWidth =  surface.GetTextSize(ammoCount) 
			local missingAmmoWidth=  surface.GetTextSize(missingAmmo) 

			ammoTotalWidth = ammoTotalWidth + surface.GetTextSize(ammoCount);
			ammoTotalWidth = ammoTotalWidth + surface.GetTextSize(missingAmmo);

			surface.SetFont("DebugFont");

			if nameWidth > boxWidth  then
				boxWidth = surface.GetTextSize(self.PrintName)+20
			end
			if ammoTotalWidth > boxWidth or self.HideName then
				boxWidth = ammoTotalWidth
			end

			if(!self.HideName) then
				boxHeight= 124
			end 

			draw.RoundedBox( 
					8, 
					ScrW()-boxWidth-24, 
					ScrH()-boxHeight-8, 
					boxWidth, 
					boxHeight,
					Color(0,0,0,160) )

			if(!self.HideName) then
				draw.DrawText( self.PrintName,
				"DebugFont",
				ScrW()-32,
				ScrH()-124,
				Color(255,255,255,255),
				TEXT_ALIGN_RIGHT)

				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.DrawRect(ScrW()-boxWidth-12, ScrH()-70, boxWidth-24, 2 )
			end

			draw.DrawText(self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType()),
			"DebugFont",
			ScrW()-32,
			ScrH()-60,
			Color(255,255,255,255),
			TEXT_ALIGN_RIGHT)

			surface.SetFont("DebugFont");
			
			draw.DrawText(ammoCount,
			"Ammo",
			ScrW()-spareAmmoWidth-36,
			ScrH()-64,
			Color(255,255,255,255),
			TEXT_ALIGN_RIGHT)

			surface.SetFont("Ammo");

			draw.DrawText(missingAmmo,
			"Ammo",
			ScrW()-spareAmmoWidth-currAmmoWidth-36,
			ScrH()-64,
			Color(0,0,0,230),
			TEXT_ALIGN_RIGHT)
		end
	end)
end
		
function SWEP:Deploy()
	self:DrawCustomHUD()
	self.init = true;

	self.HideName = false
	timer.Create( "hideName", 1.8, 0, function() self.HideName = true end )
	
	return true;
end

function SWEP:Holster()
	hook.Remove( "HUDPaint", "drawammo" )
	return true;
end
	
if CLIENT then
	local smokeparticle = Model("particle/particle_smokegrenade");

	surface.CreateFont("DebugFont", {
		font = "Century Gothic", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 48,
		weight = 400,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	})

	surface.CreateFont("Ammo", {
		font = "Corbel", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 48,
		weight = 700,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	})

	function SWEP:BloodSplatter(tr)
		local em = ParticleEmitter(tr.HitPos)
	
		for i=1, 5 do
 			local p = em:Add(smokeparticle, tr.HitPos)
			if p then
				p:SetColor(200, 0, 0)
				p:SetStartAlpha(1000)
				p:SetEndAlpha(0)
			
				p:SetLifeTime(0)
				p:SetAirResistance(100)
				 p:SetVelocity(tr.Normal * math.Rand(700, 800))

				p:SetGravity(Vector(0,0,150))
				
				p:SetDieTime(math.Rand(.4, .5))
		
				p:SetStartSize(math.random(5, 10))
				p:SetEndSize(math.random(30, 40))
				p:SetRoll(math.random(-180, 180))
				p:SetRollDelta(math.Rand(-0.1, 0.1))
				p:SetAirResistance(600)
		
				p:SetCollide(true)
				p:SetBounce(0.4)
		
				p:SetLighting(false)
		   end
		end
		  
		em:Finish()
	end

	function SWEP:ParticleTrace(tr)

		local em = ParticleEmitter(tr.StartPos)
		local currentPos = tr.StartPos

		while currentPos:Distance(tr.StartPos) < tr.HitPos:Distance(tr.StartPos) do
			local p = em:Add(smokeparticle, currentPos)
			if p then
				p:SetColor(255, 0, 0)
				p:SetStartAlpha(255)
				p:SetEndAlpha(255)
				p:SetDieTime(7)
				p:SetStartSize(0.8)
				p:SetEndSize(0.8)

				p:SetLighting(false)
			end

			currentPos = currentPos + tr.Normal
		end

	
		em:Finish()
	end

	function SWEP:GunSmoke(center)
		local em = ParticleEmitter(center)
	
		--local r = self:GetRadius()
		local pos = center;

		--local prpos = VectorRand() * r
		--prpos.z = prpos.z + 32
		local p = em:Add(smokeparticle, pos)
		if p then
			local gray = math.random(200, 255)
			p:SetColor(gray, gray, gray)
			p:SetStartAlpha(100)
			p:SetEndAlpha(5)
			p:SetVelocity((self.Owner:GetAimVector()) * math.Rand(1000, 3000))
			p:SetLifeTime(0)

			p:SetGravity(Vector(0,0,150))
			
			p:SetDieTime(math.Rand(5, 7))

			p:SetStartSize(math.random(5, 10))
			p:SetEndSize(math.random(40, 50))
			p:SetRoll(math.random(-180, 180))
			p:SetRollDelta(math.Rand(-0.1, 0.1))
			p:SetAirResistance(600)

			p:SetCollide(true)
			p:SetBounce(0.4)

			p:SetLighting(true)
		end

	
		em:Finish()
	end
end

function SWEP:Think()
	self:AdjustRecoil(-self.RecoilReductionSpeed)
	self.DebugDamage = self.DebugDamage

	self.DrawTraceSize = self.DrawTraceSize;

	if CurTime() > self:GetNextPrimaryFire() + self.Primary.Delay then
		self:UpdateSprayIndex(-self.SprayReductionSpeed)
	end
	self.HideName = self.HideName

	if (not self.init) then
		self:DrawCustomHUD()
	end
		

	if SERVER then
			hook.Add("PostDrawViewModel", "drawTraces", function()
			for k, v in ipairs(self.DrawTrace) do
				render.DrawLine( 
					v.start, 
					v.last, 
					Color( 255, 255, 255 ), 
					false )
			end
		end)
	end

	
	local owner = self:GetOwner()

	self.LerpRatio = Lerp(self.LerpRatio*self.LerpAccel, 0, 1)
	self.CurrViewPunch = LerpAngle(self.LerpRatio, self.CurrViewPunch, Angle(0,0,0))

	if(self.ViewPunchResetTime > CurTime()) then
		owner:SetViewPunchVelocity(self.CurrViewPunch)
	end
end

function SWEP:PrimaryAttack()

	for i, v in pairs(self.DrawTrace) do
			self.DrawTrace[i] = nil
		end

	if self:Clip1() > 0 then
		local cone = (self.isIronsights and 0 or self.Primary.Cone)

		local dir = self.Owner:GetAimVector()
		local angle = dir:Angle()
		angle = angle+self.Owner:GetViewPunchAngles()*2;

		dir:Add(angle:Forward())

		self:ShootBullet(
			self.Primary.NumBullets, 
			self.Owner:GetShootPos(),
			dir,
			cone, 
			self.Primary.Tracer,
			self.Primary.Force, 
			self.Primary.Damage, 
			self.Primary.Ammo, 
			self.Primary.Penetration,
			self.Primary.Ricochets,
			dir
		)

		self.Weapon:EmitSound(self.Primary.Sound)
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:TakePrimaryAmmo(1)
		self:Recoil();
		self:UpdateSprayIndex(1)


		if CLIENT then
			--self:GunSmoke(self.Owner:GetPos()+Vector(0,0,60))
		end
	else
		self:Reload();
	end
end

function SWEP:ShootBullet( numBullets, src, dir, aimcone, tracer,
	force, damage, ammo_type, remainingPenetration, remainingRicochets, shotStartAngle)

	local bullet = {}
	bullet.Num		= numBullets
	bullet.Src		= src								-- Source
	bullet.Dir		= dir								-- Dir of bullet
	bullet.Spread	= Vector( aimcone, aimcone, 0 )		-- Aim Cone
	bullet.Tracer	= tracer || 5						-- Show a tracer on every x bullets
	bullet.Force	= force || 1						-- Amount of force to give to phys objects
	bullet.Damage	= damage
	bullet.AmmoType = ammo_type || self.Primary.Ammo

	if 
		previousTrace != nil and
	 	(previousTrace.Entity:IsPlayer() or previousTrace.Entity:IsNPC()) 
	then
   		bullet.IgnoreEntity = previousTrace.Entity
   	end

	bullet.Callback = function ( att, tr, dmg )
		self:Falloff( att, tr, dmg)
		self.DebugDamage = dmg:GetDamage()
		
		self:OnDoorShot(tr.Entity, dir);

		--Calculate  the angle difference between shot direction and shot hit position
		local vectorAngleDiff = dir:Dot(tr.HitNormal);
		vectorAngleDiff = vectorAngleDiff / (dir:Length()*tr.HitNormal:Length())
		vectorAngleDiff = math.deg(math.acos(vectorAngleDiff))
		print(vectorAngleDiff)

		local newTrace = {}
		newTrace.start = src
		newTrace.last = tr.HitPos
		table.insert(self.DrawTrace, newTrace)
	
		
		if SERVER and !tr.HitSky then
			if(tr.HitGroup == 1) then
				--self:BloodSplatter(tr)
			elseif !tr.Entity:IsPlayer() and !tr.Entity:IsNPC() then
				local smokeEffect = ents.Create("spawner_smoke")
				--smokeEffect.Direction = tr.HitNormal
				smokeEffect:SetPos(tr.HitPos+tr.HitNormal)
				smokeEffect:SetAngles(tr.HitNormal:Angle())
				smokeEffect:SetMaterial("NULL")
				smokeEffect:SetSolid(0);
				smokeEffect:DrawShadow(false)
				smokeEffect:Spawn()
			end
		end

		if CLIENT then
			--self:ParticleTrace(tr)
		end

	if
		--tr.Entity != NULL and tr.Entity:IsFlagSet(FL_WORLDBRUSH) and
		vectorAngleDiff < 110 and
		remainingRicochets > 0 
	then
		if SERVER then
			--print("Shot Ricochet, remaining Ricochets = " .. remainingRicochets)
		end

		--Determine the directon of a reflectedShot
		local reflectVector =  dir-2*(dir:Dot(tr.HitNormal))*tr.HitNormal

		self:Ricochet( tr, remainingPenetration, remainingRicochets, shotStartAngle, reflectVector )
	else
		if SERVER then
			--print("Shot Penetrated, remaining Penetration = " .. remainingPenetration)
		end
		self:Penetrate( tr, remainingPenetration, remainingRicochets, shotStartAngle )
	end
		
	
		--[[if tr.Entity != NULL and tr.DispFlags == 0 then
			self:Penetrate( tr, remainingPenetration, remainingRicochets )
		end]]
	end

	self.Owner:FireBullets( bullet )

	self:ShootEffects()
end

function SWEP:Penetrate(tr, remainingPenetration, remainingRicochets, shotStartAngle)

	if remainingPenetration <= 0.01 then return end

	local leftSolid = false;
	local traceResultLength = 1;
	local shotStartNormal =  shotStartAngle:GetNormalized();

	local trace	= {}
	trace.mask	= MASK_SHOT
	trace.start = tr.HitPos + shotStartNormal;
	trace.endpos = trace.start  + shotStartNormal;
	
	local traceResult;

	--Determine the length of the trace in units
	while traceResultLength < remainingPenetration and !leftSolid do
		traceResult = util.TraceLine(trace)

		if
			(tr.Entity != NULL and traceResult.Entity != tr.Entity) or
			(tr.Entity == NULL and !traceResult.HitWorld)
		then
			leftSolid = true
		else
			trace.start = trace.endpos
			trace.endpos = trace.endpos+shotStartNormal

			traceResultLength = traceResultLength+1;
		end
	end

	remainingPenetration = (remainingPenetration-traceResultLength)

	if SERVER then
		--print("Left wall after " .. traceResultLength .. " units. Remaining Penetration = " .. remainingPenetration .. " units")
	end
   
   	if (remainingPenetration <= 0.01 or !leftSolid) then return end
   
	self:ShootBullet(
		1, 
		trace.endpos,
		shotStartNormal,
		cone, 
		0,
		self.Primary.Force, 
		self.Primary.Damage*(remainingPenetration/self.Primary.Penetration), 
		self.Primary.Ammo, 
		remainingPenetration,
		remainingRicochets,
		shotStartAngle)
end

function SWEP:Ricochet(tr, remainingPenetration, remainingRicochets, shotStartAngle, reflectVector )
	self:ShootBullet(
		1, 
		tr.HitPos,
		reflectVector,
		cone, 
		0,
		self.Primary.Force, 
		self.Primary.Damage*(remainingPenetration/self.Primary.Penetration), 
		self.Primary.Ammo, 
		remainingPenetration,
		remainingRicochets-1,
		reflectVector:GetNormalized())
end

function SWEP:OnDoorShot(door)
	if door:GetClass() == "prop_door_rotating" and !door:GetInternalVariable("m_bLocked") and SERVER then

		door:SetSaveValue("soundcloseoverride", "NULL")
		door:SetSaveValue("soundopenoverride", "NULL")
		door:SetSaveValue("soundmoveoverride", "NULL")
		door:SetSaveValue("soundlockedoverride", "NULL")
		door:SetSaveValue("soundunlockedoverride", "NULL")

		local doorRagdoll = ents.Create("prop_physics")
		doorRagdoll:DrawShadow(false)
		doorRagdoll:SetModel(door:GetModel())
		doorRagdoll:SetPos(door:GetPos())
		doorRagdoll:SetAngles(door:GetAngles())
		doorRagdoll:SetSkin(door:GetSkin())
		doorRagdoll:DrawShadow(true)

		--PrintTable(door:GetSaveTable());
		--This is a hack job to handle some doors that control VIS in an area.
		--Basically hide everything about the door, disable collision and open it.
		--Once its open, then delete it.
		--WIP NEED FIX FOR DOUBLE DOORS
		door:RemoveAllDecals();
		door:Input("Open")
		door:DrawShadow(false);
		door:SetMaterial("NULL")
		door:SetSolid(0);
		
		door:SetSaveValue("locked", true)
		

		if(door:GetInternalVariable("m_hMaster") != NULL) then
			self:OnDoorShot(door:GetInternalVariable("m_hMaster"))
		end

		timer.Simple(0, function() door:Remove() end)
		doorRagdoll:Spawn()
	end
end

function SWEP:Recoil()
	
	local owner = self:GetOwner()
	local recoil = self:GetCurrRecoil()
	
	local hRecoil = -self.Spray[math.Round(self.SprayIndex)][1]
	local vRecoil = -self.Spray[math.Round(self.SprayIndex)][2]
	
	local eyeAngle = owner:EyeAngles()
	eyeAngle.p = eyeAngle.p + vRecoil;
	eyeAngle.y = eyeAngle.y - hRecoil;
	
	self.CurrViewPunch =  Angle(vRecoil, hRecoil, 0)

	self.LerpRatio = 0.01;
	self.ViewPunchResetTime = CurTime() + self.ViewPunchResetDelay
	
	--owner:SetEyeAngles(eyeAngle)
	--owner:SetViewPunchVelocity(recoilAngle)
	owner:SetViewPunchVelocity(self.CurrViewPunch)

	self:AdjustRecoil(0.4)
end

function SWEP:Falloff( att, tr , dmg)

	-- Apply bullet falloff
	if att and att:IsValid() then
		local dist = (tr.HitPos - tr.StartPos):Length()
		self.DebugShotDistance = dist;

		if self.Primary.FalloffMin > -1 and self.Primary.FalloffMax > -1 then
			if dist > self.Primary.FalloffMin then
				local addedScale = (1-self.Primary.Falloffscale)*(1-(dist/self.Primary.FalloffMax))
				local scaledDamage = self.Primary.Falloffscale + addedScale

				if scaledDamage <= self.Primary.Falloffscale then 
					scaledDamage = self.Primary.Falloffscale 
				end

				if scaledDamage >= 1 then 
					scaledDamage = 1 
				end

				dmg:ScaleDamage(scaledDamage) 
			end
		end
	end
end

function SWEP:ADS()
	self.isIronsights = !self.isIronsights
	self:AdjustZoom()
end 

function SWEP:UpdateSprayIndex(value)

	local newSpray = self.SprayIndex+value;

	if(newSpray < 1) then
		newSpray = 1
	end

	if(newSpray > self.Primary.ClipSize) then
		newSpray = self.Primary.ClipSize
	end

	self.SprayIndex = newSpray
end

function SWEP:AdjustRecoil(newRecoil)
	local recoil = self:GetCurrRecoil()+newRecoil
	
	if recoil > 1 then
		recoil = 1
	elseif recoil < 0 then
		recoil = 0
	end
	self:SetCurrRecoil(recoil) 
end

function SWEP:AdjustZoom()
	if(!self.isIronsights) then
		self:GetOwner():SetFOV(self.ViewModelFOV+self.Zoom, self.ADSSpeed)
	else
		self:GetOwner():SetFOV(self.ViewModelFOV, self.ADSSpeed)
	end
end

function SWEP:AdjustViewModel()
	if CLIENT then
		if(self.isIronsights) then 
			offset = LerpVector(self.ADSSpeed/4, self.CurrIronSightPos, self.IronSightsPos)
		else
			offset= LerpVector(self.ADSSpeed/8, self.CurrIronSightPos, Vector(0,0,0))
		end

		offset.y = offset.y - self:GetCurrRecoil()/50
		offset.z = offset.z - self:GetCurrRecoil()/50

		self.CurrIronSightPos = offset

		--print(self.CurrIronSightPos)
	end
end

function SWEP:AdjustEyeRotate()
	local ply = self:GetOwner()

	local left = (ply:KeyDown(IN_MOVELEFT) and 1 or 0)
	local right = (ply:KeyDown(IN_MOVERIGHT) and 1 or 0)

	local rotDir = left-right
	
	if rotDir == 1 then
		self.CurrEyeRot = Lerp(.03, self.CurrEyeRot, self.EyeRotateMax)
	elseif rotDir == -1 then
		self.CurrEyeRot = Lerp(.03, self.CurrEyeRot, -self.EyeRotateMax)
	else
		self.CurrEyeRot = Lerp(.03, self.CurrEyeRot, 0)
	end
end

function SWEP:Reload()
 
	//if ( CLIENT ) then return end
	
	if self.ReloadingTime and CurTime() <= self.ReloadingTime then return end
 
	if ( self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
 
	self.SprayIndex = 1;
 
	if(self.isIronsights) then
		self:ADS()
	end

		self:DefaultReload( ACT_VM_RELOAD )
	end

 
end

function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 1, "CurrRecoil")
end

function SWEP:GetViewModelPosition(EyePos, EyeAng)
	if CLIENT then

		local Mul = 1.0

		self:AdjustViewModel()
		self:AdjustEyeRotate()
	
		local offset = self.CurrIronSightPos;

		if self.IronSightsAng then
			EyeAng = EyeAng * 1
			EyeAng:RotateAroundAxis( EyeAng:Right(),    (self.IronSightsAng.x+self:GetCurrRecoil()/2) * Mul )
			EyeAng:RotateAroundAxis( EyeAng:Up(),       (self.IronSightsAng.y-self:GetCurrRecoil()/50) * Mul )
			EyeAng:RotateAroundAxis( EyeAng:Forward(),  (self.IronSightsAng.z-self.CurrEyeRot-self:GetCurrRecoil()/10) * Mul )
		end

		EyePos = EyePos + offset.x * EyeAng:Right() * Mul
		EyePos = EyePos + offset.y * EyeAng:Forward() * Mul
		EyePos = EyePos + offset.z * EyeAng:Up() * Mul

		return EyePos, EyeAng
	end
end

function SWEP:SecondaryAttack()
	self:ADS()
end