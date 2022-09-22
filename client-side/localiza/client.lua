-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local typeCars = {}
local typeBikes = {}
local typeWorks = {}
local typeRental = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADFOCUS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("closeSystem",function(data)
	vRP.removeObjects()
	SetNuiFocus(false,false)
	SetCursorLocation(0.5,0.5)
	SendNUIMessage({ action = "closeSystem" })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("smartphone-app:updateVehicles")
AddEventHandler("smartphone-app:updateVehicles",function(Cars,Bikes,Works,Rental)
	typeCars = Cars
	typeBikes = Bikes
	typeWorks = Works
	typeRental = Rental
end)

function aRP.updateVehicles(Cars,Bikes,Works,Rental)
	typeCars = Cars
	typeBikes = Bikes
	typeWorks = Works
	typeRental = Rental
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCARROS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestCarros",function(data,cb)
	cb({ result = typeCars })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTMOTOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestMotos",function(data,cb)
	cb({ result = typeBikes })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSERVICOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestServicos",function(data,cb)
	cb({ result = typeWorks })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTALUGUEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestAluguel",function(data,cb)
	cb({ result = typeRental })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPOSSUIDOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestPossuidos",function(data,cb)
	cb({ result = vSERVER.requestPossuidos() })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBUY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestBuy",function(data,cb)
	vSERVER.requestBuy(data["name"])
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTRENTAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestRental",function(data,cb)
	vSERVER.requestRental(data["name"])
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- RENTALMONEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("rentalMoney",function(data,cb)
	vSERVER.rentalMoney(data["name"])
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTTAX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestTax",function(data,cb)
	vSERVER.requestTax(data["name"])
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSELL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestSell",function(data,cb)
	vSERVER.requestSell(data["name"])
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DRIVEABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local vehDrive = nil
local benDrive = false
local benCoords = { -33.12,-1096.93,27.26 }

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTDRIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestDrive",function(data,cb)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local distance = #(coords - vector3(benCoords[1],benCoords[2],benCoords[3]))

	if distance <= 3 then
		vRP.removeObjects()
		SetNuiFocus(false,false)
		SetCursorLocation(0.5,0.5)
		SendNUIMessage({ action = "closeSystem" })

		local driveIn,vehPlate = vSERVER.startDrive()
		if driveIn then
			TriggerEvent("races:insertList",true)
			TriggerEvent("player:blockCommands",true)
			TriggerEvent("Notify","azul","Teste iniciado, para finalizar saia do veículo.",5000)

			Citizen.Wait(1000)

			vehCreate(data["name"],vehPlate)

			Citizen.Wait(1000)

			SetPedIntoVehicle(ped,vehDrive,-1)
			benDrive = true
		end
	else
		TriggerEvent("Notify","amarelo","Dirija-se até a <b>Benefactor</b> para efetuar o teste.",2000)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHCREATE
-----------------------------------------------------------------------------------------------------------------------------------------
function vehCreate(vehName,vehPlate)
	local mHash = GetHashKey(vehName)

	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		Citizen.Wait(1)
	end

	if HasModelLoaded(mHash) then
		vehDrive = CreateVehicle(mHash,-68.29,82.77,71.21,65.2,false,false)

		SetEntityInvincible(vehDrive,true)
		SetVehicleOnGroundProperly(vehDrive)
		SetVehicleNumberPlateText(vehDrive,vehPlate)
		SetEntityAsMissionEntity(vehDrive,true,true)
		SetVehicleHasBeenOwnedByPlayer(vehDrive,true)
		SetVehicleNeedsToBeHotwired(vehDrive,false)

		SetModelAsNoLongerNeeded(mHash)
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADDRIVE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 999
		if benDrive then
			timeDistance = 1
			DisableControlAction(1,69,false)

			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				Citizen.Wait(1000)

				benDrive = false
				vSERVER.removeDrive()
				DeleteEntity(vehDrive)
				TriggerEvent("races:insertList",false)
				TriggerEvent("player:blockCommands",false)
				SetEntityCoords(ped,benCoords[1],benCoords[2],benCoords[3],1,0,0,0)
			end
		end

		Citizen.Wait(timeDistance)
	end
end)