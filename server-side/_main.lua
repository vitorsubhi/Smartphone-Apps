-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
Tunnel = module("vrp","lib/Tunnel")
Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("smartphone-app",cRP)
vCLIENT = Tunnel.getInterface("smartphone-app")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
actived = {}
typeCars = {}
typeBikes = {}
typeWorks = {}
typeRental = {}

local version = module("version")
PerformHttpRequest("https://raw.githubusercontent.com/vitorsubhi/Smartphone-Apps/master/version.lua",function(err,text,headers)
	if err == 200 then
		text = string.gsub(text,"return ","")
		local r_version = tonumber(text)
		if version ~= r_version then
			print("\n^5[Alternative Smartphone-Apps]: ^1Uma atualização do Smartphone-Apps foi detectada em:\n^2https://github.com/vitorsubhi/Smartphone-Apps/")
			print("^4[Última versão]: ".. r_version)
			print("^3[Versão atual]: ".. version.."^7")
		else 
			print("^5[Alternative Smartphone-Apps]: ^7Você está utilizando a versão mais recente do Smartphone-Apps.^7")
		end
	else
		print("^5[Alternative Smartphone-Apps]: ^1Não foi possível verificar versão remota.^7")
	end
end, "GET", "")