--- Library for interfacing with ACF entities
-- @name fin3
-- @class library
-- @libtbl fin3_library
SF.RegisterLibrary("fin3")

local checkluatype = SF.CheckLuaType

return function(instance)
	local checktype = instance.CheckType
	local fin3_library = instance.Libraries.fin3
	local vec_meta, vwrap, vunwrap = instance.Types.Vector, instance.Types.Vector.Wrap, instance.Types.Vector.Unwrap

	local getent = instance.Types.Entity.Unwrap

	--- Adds a new fin to an entity
	--- Fin creation data table structure:
	--- finType: string [model name]
	--- upAxis: vector
	--- forwardAxis: vector
	--- inducedDrag: boolean
	--- zeroLiftAngle: number [1 - 8]
	--- efficiency: number [0.1 - 1.5]
	-- @param ent Entity Entity to add the fin to
	-- @param data table Fin creation data table
	function fin3_library.create(ent, data)
		local ent = getent(ent)
		if ent:CPPIGetOwner() ~= instance.player then return end
		local finType = data.finType or "cambered"
		local zeroLiftAngle = data.zeroLiftAngle or 0
		local efficiency = data.efficiency or 1
		local inducedDrag = data.inducedDrag
		checktype(data.upAxis, vec_meta)
		checktype(data.forwardAxis, vec_meta)
		checkluatype(finType, TYPE_STRING)
		checkluatype(zeroLiftAngle, TYPE_NUMBER)
		checkluatype(efficiency, TYPE_NUMBER)
		checkluatype(inducedDrag, TYPE_BOOL)
		if not Fin3.models[finType] then return SF.Throw("unknown finType") end
		Fin3.new(instance.player, ent, {
			upAxis = vunwrap(data.upAxis),
			forwardAxis = vunwrap(data.forwardAxis),
			finType = finType,
			zeroLiftAngle = math.Clamp(zeroLiftAngle, 1, 8),
			efficiency = math.Clamp(efficiency, 0.1, 1.5),
			inducedDrag = data.inducedDrag,
		})
	end
end
