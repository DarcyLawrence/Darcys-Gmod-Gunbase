AddCSLuaFile()

SWEP.HoldType              	= "ar2"

if CLIENT then
   SWEP.PrintName          	= "JL_Base"
   SWEP.Slot               	= 2

   SWEP.ViewModelFlip      	= false
   SWEP.ViewModelFOV       	= 72
   
   SWEP.DrawCrosshair		= true;
end

SWEP.Base                  	= "weapon_base"

SWEP.Kind                  	= WEAPON_HEAVY
SWEP.WeaponID              	= AMMO_M16

SWEP.Primary.Delay         	= .1

SWEP.Primary.LRecoil        = 1
SWEP.Primary.RRecoil        = 1
SWEP.Primary.URecoil        = 1
SWEP.Primary.DRecoil        = 0
SWEP.RecoilReductionSpeed = .05

SWEP.Primary.Automatic     	= true
SWEP.Primary.Ammo          	= "Pistol"
SWEP.Primary.Damage        	= 23
SWEP.Primary.Cone          	= 0.1
SWEP.Primary.ClipSize      	= 20
SWEP.Primary.ClipMax      	= 60
SWEP.Primary.DefaultClip   	= 20
SWEP.Primary.Sound         	= Sound( "Weapon_M4A1.Single" )

SWEP.Secondary.Automatic	= false

SWEP.Primary.NumBullets		= 1

SWEP.Primary.Force			= 10

SWEP.Primary.Tracer			= 1

SWEP.AutoSpawnable         	= true
SWEP.Spawnable             	= true
SWEP.AmmoEnt               	= "item_ammo_pistol_ttt"

SWEP.UseHands              	= true
SWEP.ViewModel             	= "models/weapons/soviet_carbine/soviet_carbine.mdl"
SWEP.WorldModel            	= "models/weapons/soviet_carbine/w_soviet_carbine.mdl"

SWEP.IronSightsPos = Vector( -3.680, -12.2687, 6.88 )
SWEP.IronSightsAng = Vector( -4.8723, -2.10, -2.5 )

SWEP.BobScale 				= 0.1
SWEP.SwayScale				= 0

SWEP.Spread					= .074
SWEP.MaxSpread				= .20
SWEP.SpreadReductionSpeed	= 0.01

SWEP.Zoom					= 30
SWEP.ADSSpeed				= .3

SWEP.EyeRotateMax			= 5

currMov = 1;

SWEP.Spray = {
	[1] = {0, .5},
	[2] = {.50, .5},
	[3] = {.50, 1},
	[4] = {0.25, 1},
	[5] = {0, 1.5},
	[6] = {.50, 2},
	[7] = {0, 2.25},
	[8] = {0, 2.5},
	[9] = {.25, 2.5},
	[10] = {.5, 2.5},
	[11] = {.75, 2.75},
	[12] = {.25, 2.9},
	[13] = {-.5, 3.1},
	[14] = {-.5, 3.2},
	[15] = {-1, 3.3},
	[16] = {0, 3.4},
	[17] = {0, 3.45},
	[18] = {0, 3.5},
	[19] = {0, 3.55},
	[20] = {0, 3.6}
}

SWEP.SprayIndex = 1;
SWEP.SprayReductionSpeed = 0.5;


	
if CLIENT then
	local smokeparticle = Model("particle/particle_smokegrenade");

		surface.CreateFont("DebugFont", {
	font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 32,
	weight = 700,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
	})

	function SWEP:CreateSmoke(center)
		local em = ParticleEmitter(center)
	
		--local r = self:GetRadius()

		   --local prpos = VectorRand() * r
		   --prpos.z = prpos.z + 32
		   local p = em:Add(smokeparticle, center)
		   if p then
			  local gray = math.random(200, 255)
			  p:SetColor(gray, gray, gray)
			  p:SetStartAlpha(200)
			  p:SetEndAlpha(0)
			  p:SetVelocity((self.Owner:GetAimVector()) * math.Rand(600, 800))
			  p:SetLifeTime(0)
			  p:SetAirResistance(100)

			  p:SetGravity(Vector(0,0,150))
			  
			  p:SetDieTime(math.Rand(5, 7))
	
			  p:SetStartSize(math.random(5, 10))
			  p:SetEndSize(math.random(50, 60))
			  p:SetRoll(math.random(-180, 180))
			  p:SetRollDelta(math.Rand(-0.1, 0.1))
			  p:SetAirResistance(600)
	
			  p:SetCollide(true)
			  p:SetBounce(0.4)
	
			  p:SetLighting(false)
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

			p:SetLighting(false)
		end

	
		em:Finish()
	end
end

function SWEP:Think()
		self:AdjustSpread(-self.SpreadReductionSpeed)  
		self:AdjustRecoil(-self.RecoilReductionSpeed)

		if CurTime() > self:GetNextPrimaryFire() + self.Primary.Delay then
			self:UpdateSprayIndex(-self.SprayReductionSpeed)
		end

	hook.Add( "HUDPaint", "drawsometext", function()



	surface.SetFont( "DebugFont" )
	surface.SetTextColor( 255, 255, 255 )
	surface.SetTextPos( 128, 128 ) 
	surface.DrawText( "Spray Index: " .. self.SprayIndex)
end )
end

function SWEP:PrimaryAttack()

	if self:Clip1() > 0 then
		local cone = (self.isIronsights and 0 or self.Primary.Cone)

		self:ShootBullet(
			self.Primary.Damage, 
			self.Primary.NumBullets, 
			cone, 
			self.Primary.Ammo, 
			self.Primary.Force, 
			self.Primary.Tracer)
			
		--self:TakePrimaryAmmo(1)

		self.Weapon:EmitSound(self.Primary.Sound)
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:TakePrimaryAmmo(1)

		self:Recoil();
		self:AdjustSpread(self.Spread);

		self:UpdateSprayIndex(1)

		for i=1,self.Primary.ClipSize do
			--print(self.Spray[i][1] .. ", " .. self.Spray[i][2])
		end

		if CLIENT then
			--self:GunSmoke(self.Owner:GetPos()+Vector(0,0,60))
		end
	end
end

function SWEP:ShootBullet( damage, num_bullets, aimcone, ammo_type, force, tracer )

	local dir = self.Owner:GetAimVector()
	local angle = dir:Angle()
	angle = angle+self.Owner:GetViewPunchAngles()*2;

	dir:Add(angle:Forward())

	local bullet = {}
	bullet.Num		= num_bullets
	bullet.Src		= self.Owner:GetShootPos()			-- Source
	bullet.Dir		= dir-- Dir of bullet
	bullet.Spread	= Vector( aimcone, aimcone, 0 )		-- Aim Cone
	bullet.Tracer	= tracer || 5						-- Show a tracer on every x bullets
	bullet.Force	= force || 1						-- Amount of force to give to phys objects
	bullet.Damage	= damage
	bullet.AmmoType = ammo_type || self.Primary.Ammo

	bullet.Callback = function ( att, tr, dmg )
		if CLIENT and !tr.HitSky then
			self:CreateSmoke(tr.HitPos)
		end
	end

	self.Owner:FireBullets( bullet )

	self:ShootEffects()
end

function SWEP:Recoil()
	
	local owner = self:GetOwner()
	local recoil = self:GetCurrRecoil()
	
	local hRecoil = -self.Spray[math.Round(self.SprayIndex)][1]
	local vRecoil = -self.Spray[math.Round(self.SprayIndex)][2]
	
	local eyeAngle = owner:EyeAngles()
	eyeAngle.p = eyeAngle.p + vRecoil;
	eyeAngle.y = eyeAngle.y - hRecoil;
	

	

	local recoilAngle = Angle(vRecoil, hRecoil, 0)
	
	--owner:SetEyeAngles(eyeAngle)
	--owner:SetViewPunchVelocity(recoilAngle)
	owner:ViewPunch(recoilAngle)

	

	self:AdjustRecoil(0.4)
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

function SWEP:AdjustSpread(newSpread)
	local spread = self.CurrSpread+newSpread
	
	if spread > self.MaxSpread then
		spread = self.MaxSpread
	elseif spread < 0 then
		spread = 0
	end
	
	self.CurrSpread = spread;
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

SWEP.CurrIronSightPos = Vector(0,0,0);
SWEP.CurrEyeRot = 0;
SWEP.isIronsights = false;
SWEP.CurrSpread = 0;

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