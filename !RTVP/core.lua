--[[
Raka's Text-based Video Player
]]

local ADDON_NAME, ns = ...

-- 初始化聊天框
local CHATWINDOW_INDEX = 0
for i = 1, NUM_CHAT_WINDOWS do
	name, _, _, _, _, _, _, _, _, _ = GetChatWindowInfo(i)
	if string.lower(name) == 'rtvp' then
		CHATWINDOW_INDEX = i
		break
	end
end

if CHATWINDOW_INDEX == 0 then
	print('|cFFFF5151RTVP|r |cFFFF0000' .. '[警告]|r 未找到对应的聊天窗口。')
	print('|cFFFF5151RTVP|r ' .. '请创建一个叫做“RTVP”的聊天框后重新加载界面（/reload）。')
end

print('|cFFFF5151RTVP|r ' .. '加载完成。使用/rtvp查看可用命令。')

local CHATWINDOW = _G['ChatFrame' .. CHATWINDOW_INDEX]

local frames = {}

local function RTVP_Stage()
	local stage = ''
	for i = 1, ns.videoMeta['h'] do
		for j = 1, ns.videoMeta['w'] do
			if i % 2 == 0 then
				stage = stage .. '|cFF000000■|r '
			else
				stage = stage .. '|cFFFFFFFF■|r '
			end
		end
	end
	CHATWINDOW:Clear()
	CHATWINDOW:AddMessage('  ' .. stage)
end

local f = CreateFrame('Frame', nil, UIParent)
local currentFrame = 1
local currentTimestamp = 0

local function playbackHandler(self, elapsed)
	currentTimestamp = currentTimestamp + elapsed
	currentFrameTimestamp = ns.videoFrames[currentFrame][1]
	if currentFrame < #ns.videoFrames then
		nextFrameTimeStamp = ns.videoFrames[currentFrame + 1][1]
	else
		nextFrameTimeStamp = 0
	end

	if nextFrameTimeStamp ~= 0 then
		while (currentTimestamp > nextFrameTimeStamp) do
			currentFrame = currentFrame + 1 --skip frame
			currentFrameTimestamp = ns.videoFrames[currentFrame][1]
			nextFrameTimeStamp = ns.videoFrames[currentFrame + 1][1]
		end
	end

	if (currentTimestamp >= currentFrameTimestamp) then
		-- print('|cFFFF5151RTVP|r ' .. 'Playing frame ' .. currentFrame .. '|r.')
		CHATWINDOW:Clear()
		CHATWINDOW:AddMessage('  ' .. ns.videoFrames[currentFrame][2])
		if currentFrame >= #ns.videoFrames then
			f:SetScript('OnUpdate', nil)
			-- print('|cFFFF5151RTVP|r |cFFFF0000' .. 'STOP.' .. '|r.')
			return
		end
		currentFrame = currentFrame + 1	
	end


end

SLASH_RTVP1 = '/rtvp'
local function aphandler(msg)
	msg = string.lower(msg)
	if msg:match('^stage') then
		RTVP_Stage()
	elseif msg:match('^play') then
		currentFrame = 1
		currentTimestamp = 0
		f:SetScript('OnUpdate', playbackHandler)
	elseif msg:match('^stop') then
		currentFrame = 1
		currentTimestamp = 0
		f:SetScript('OnUpdate', nil)
	else
		print('|cFFFF5151RTVP|r ' .. '|cFFFF0000命令|r：stage - 显示一个预览画面，黑白相间，用于调整聊天框大小；play - 播放；stop - 停止。')
	end
end
SlashCmdList['RTVP'] = aphandler