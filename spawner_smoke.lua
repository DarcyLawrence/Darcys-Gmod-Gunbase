
AddCSLuaFile()


ENT.Type = "anim"

function ENT:Initialize()
   
end

if CLIENT then

   local smokeparticle = Model("particle/particle_smokegrenade");

    timer.Simple(0, function() 
        self:CreateSmoke();
        self:delete();
    end)

   function SWEP:CreateSmoke()
		local em = ParticleEmitter(self:GetPos())
	
		--local r = self:GetRadius()

		   --local prpos = VectorRand() * r
		   --prpos.z = prpos.z + 32
		   local p = em:Add(smokeparticle, self:GetPos())
		   if p then
			  local gray = math.random(200, 255)
			  p:SetColor(gray, gray, gray)
			  p:SetStartAlpha(200)
			  p:SetEndAlpha(0)
			  p:SetVelocity(0)
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
end