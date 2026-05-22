-- Hammerspoon configuration for yabai animations (SIP-Safe)
-- Managed by GNU Stow from ~/dotfiles/hammerspoon/.hammerspoon/init.lua

-- Animation settings
hs.window.animationDuration = 0.15
local ANIM_TIME = 0.2
local FADE_ALPHA = 0.3

-- Window filter to monitor all windows
local wf = hs.window.filter.new(nil)

-- Function to draw a fade/zoom animation
local function animateWindow(rect, type)
    local canvas = hs.canvas.new(rect)
    
    if type == "create" then
        -- Creation: Small and transparent -> Full and semi-transparent -> Delete
        canvas:insertElement({
            type = "rectangle",
            action = "fill",
            fillColor = {white=1, alpha=FADE_ALPHA},
            roundedRectRadii = {xRadius=10, yRadius=10}
        })
        canvas:alpha(0)
        canvas:show()
        
        local alpha = 0
        hs.timer.doEvery(0.02, function(timer)
            alpha = alpha + 0.05
            canvas:alpha(alpha)
            if alpha >= FADE_ALPHA then
                timer:stop()
                canvas:fadeOut(ANIM_TIME)
                hs.timer.doAfter(ANIM_TIME, function() canvas:delete() end)
            end
        end)
        
    elseif type == "destroy" then
        -- Destruction: Capture last frame and shrink/fade
        canvas:insertElement({
            type = "rectangle",
            action = "fill",
            fillColor = {white=1, alpha=FADE_ALPHA},
            roundedRectRadii = {xRadius=10, yRadius=10}
        })
        canvas:show()
        canvas:fadeOut(ANIM_TIME)
        hs.timer.doAfter(ANIM_TIME, function() canvas:delete() end)
    end
end

-- Subscribe to creation
wf:subscribe(hs.window.filter.windowCreated, function(win)
    if win:isStandard() then
        animateWindow(win:frame(), "create")
    end
end)

-- Track frames for destruction (since the window object is invalid after destruction)
local lastFrames = {}
wf:subscribe(hs.window.filter.windowAllowed, function(win)
    lastFrames[win:id()] = win:frame()
end)

wf:subscribe(hs.window.filter.windowNotAllowed, function(win, name, event)
    local id = win:id()
    if lastFrames[id] then
        animateWindow(lastFrames[id], "destroy")
        lastFrames[id] = nil
    end
end)

-- Optional: Flash on focus
wf:subscribe(hs.window.filter.windowFocused, function(win)
    local f = win:frame()
    local flash = hs.canvas.new(f)
    flash:insertElement({
        type = "rectangle",
        action = "fill",
        fillColor = {white=1, alpha=0.1},
        roundedRectRadii = {xRadius=10, yRadius=10}
    })
    flash:show()
    flash:fadeOut(0.1)
    hs.timer.doAfter(0.1, function() flash:delete() end)
end)

hs.alert.show("Hammerspoon Animations Loaded")
