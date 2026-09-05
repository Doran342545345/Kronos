--[[
	Kronos UI Library
	Version 1.0.0
	A modern executor-agnostic UI library.
	Published under the MIT License.
]]local a={cache={}::any}do do local function __modImpl()local b=game:GetService"HttpService"
local c=game:GetService"TweenService"
local d=game:GetService"UserInputService"
local e=game:GetService"GuiService"
local f=game:GetService"Players"

local g={}

local function getgenvSafe()
if rawget(_G,"getgenv")then
local h,i=pcall(getgenv)
if h then
return i
end
return _G
end
return _G
end

g.getgenv=getgenvSafe

g.isSecure=function()
local h=getgenvSafe()
return h and h.SecureMode==true
end

g.isMobile=function()
return d.TouchEnabled and not d.MouseEnabled
end

g.uniqId=function(h)
return(h or"K")..b:GenerateGUID(false):gsub("-","")
end


g.has=function(h)
local i=getgenvSafe()
return i and i[h]~=nil
end


local h={}
g.fs=h

local i=getgenvSafe()
local j=i and i.isfolder
local k=i and i.makefolder
local l=i and i.writefile
local m=i and i.readfile
local n=i and i.listfiles
local o=i and i.delfile

h.supported=not not(j and k and l and m)
h.makeFolder=k
h.writeFile=l
h.listFiles=n
h.deleteFile=o

h.folderExists=function(p)
if not j then
return false
end
local q,r=pcall(j,p)
return q and r,nil
end

h.ensureFolder=function(p)
if not h.supported then
return false
end
if j and pcall(j,p)then
return true
end
if k then
local q=pcall(k,p)
return q,nil
end
return false
end

h.readFile=function(p)
if not m then
return false,"no readfile"
end
local q,r=pcall(m,p)
if q then
return true,r
end
return false,r
end


g.request=function(p)
local q=getgenvSafe()
if type(q.request)=="function"then
return q.request(p)
elseif type(q.http_request)=="function"then
return q.http_request(p)
end
local r,s=pcall(function()
return b:RequestAsync{
Url=p.Url,
Method=p.Method or"GET",
Headers=p.Headers or{},
Body=p.Body,
}
end)
if r then
return{StatusCode=s.StatusCode,Body=s.Body}
end
return nil,s
end

g.encode=function(p)
return b:JSONEncode(p)
end

g.decode=function(p)
local q,r=pcall(function()
return b:JSONDecode(p)
end)
if q then
return r
end
return nil
end

g.getPlayer=function()
return f.LocalPlayer
end

g.tween=function(p,q,r)
local s=c:Create(p,q,r)
s:Play()
return s
end

g.GuiService=e
g.TweenService=c
g.UserInputService=d
g.HttpService=b
g.Players=f



g.Scale={}

g.Scale.Get=function()
local p=f.LocalPlayer
if not p then
return 1
end
local q=1
local r,s=pcall(function()
return p:FindFirstChildOfClass"PlayerGui"
end)
if r and s and s:FindFirstChild"KronosUIScale"then
q=s.KronosUIScale.Scale
end
return q
end

g.Scale.Set=function(p)
local q=f.LocalPlayer
if not q then
return
end
pcall(function()
local r=q:WaitForChild"PlayerGui"
local s=r:FindFirstChild"KronosUIScale"
if not s then
s=Instance.new"UIScale"
s.Name="KronosUIScale"
s.Parent=r
end
s.Scale=p
end)
end

return g end function a.a():typeof(__modImpl())local b=a.cache.a if not b then b={c=__modImpl()}a.cache.a=b end return b.c end end do local function __modImpl()


local b={}
b.__index=b

local function newValue(c,d)
local e=d
local f={}

local g={
_value=function()
return e
end,
Set=function(g,h,i)
if e==h then
return false
end
local j=e
e=h
if not i then
for k,l in ipairs(f)do
task.spawn(function()
l(h,j)
end)
end
end
return true
end,
Get=function()
return e
end,
Changed=function(g,h)
f[#f+1]=h
end,
Destroy=function()
table.clear(f)
end,
}

g.__index=g
g.value=e
return g
end

b.new=newValue



local c={}
c.__index=c

function c.new()
local d=setmetatable({jobs={}},c)
return d
end

function c.add(d,e)
d.jobs[#d.jobs+1]=e
end

function c.run(d)
for e,f in ipairs(d.jobs)do
f()
end
d.jobs={}
end

b.Batch=c

return b end function a.b():typeof(__modImpl())local b=a.cache.b if not b then b={c=__modImpl()}a.cache.b=b end return b.c end end do local function __modImpl()a.a()a.b()







local b={}





local function toColor3(c)
if typeof(c)=="Color3"then
return c
end
if typeof(c)=="table"and c.r then
return Color3.new(c.r,c.g,c.b)
end
return Color3.new(1,1,1)
end

local function isGradient(c)
return type(c)=="table"and not c.r and(c["0"]~=nil or c[0]~=nil)
end

local c={}

function c.new(d,e)
local f={}
for g in pairs(d)do
f[#f+1]=g
end
table.sort(f,function(g,h)
return tonumber(g)<tonumber(h)
end)
local g={}
for h,i in ipairs(f)do
local j=tonumber(i)/100
local k=toColor3(d[i])
g[#g+1]=ColorSequenceKeypoint.new(j,k)
end
return{
kind="gradient",
sequence=g,
rotation=e or 90,
points=d,
}
end

c.toSequence=function(d)
return ColorSequence.new(d.sequence)
end

b.Gradient=c





local d={
name="Dark",
base=nil,
dark=true,

window={
background=c.new({["0"]=Color3.fromRGB(13,15,21),["100"]=Color3.fromRGB(20,23,33)},90),
foreground=Color3.fromRGB(24,27,39),
element=Color3.fromRGB(31,35,48),
sidebar=Color3.fromRGB(14,16,23),
sidebarItem=Color3.fromRGB(26,29,41),
header=Color3.fromRGB(20,23,33),
topbar=Color3.fromRGB(23,26,38),
online=Color3.fromRGB(35,38,52),
rail=Color3.fromRGB(11,13,19),
carry=Color3.fromRGB(33,36,50),
carry2=Color3.fromRGB(40,44,60),
},

text={
window=Color3.fromRGB(255,255,255),
element=Color3.fromRGB(255,255,255),
button=Color3.fromRGB(255,255,255),
slider=Color3.fromRGB(230,233,242),
input=Color3.fromRGB(255,255,255),
dropdown=Color3.fromRGB(255,255,255),
label=Color3.fromRGB(255,255,255),
desc=Color3.fromRGB(166,170,186),
title=Color3.fromRGB(255,255,255),
subtile=Color3.fromRGB(150,154,170),
notification=Color3.fromRGB(255,255,255),
},

stroke={
window=Color3.fromRGB(255,255,255),
element=Color3.fromRGB(255,255,255),
button=Color3.fromRGB(255,255,255),
slider=Color3.fromRGB(255,255,255),
input=Color3.fromRGB(255,255,255),
dropdown=Color3.fromRGB(255,255,255),
sidebar=Color3.fromRGB(255,255,255),
},

rounded={
window=12,
outer=13,
element=6,
button=8,
slider=6,
input=8,
dropdown=8,
colorpicker=4,
notification=12,
dialog=14,
},

scroll={
color=Color3.fromRGB(84,88,108),
transparency=1,
stroke=Color3.fromRGB(255,255,255),
thickness=4,
},

slider={
fill=Color3.fromRGB(255,70,85),
fillTransparency=1,
track=Color3.fromRGB(42,46,62),
stroke=Color3.fromRGB(255,255,255),
thickness=4,
handle=Color3.fromRGB(255,70,85),
},

accent={
color=Color3.fromRGB(255,70,85),
hover=Color3.fromRGB(255,96,109),
active=Color3.fromRGB(226,54,68),
gradient=c.new({["0"]=Color3.fromRGB(255,70,85),["100"]=Color3.fromRGB(255,105,135)},90),
},

status={
success=Color3.fromRGB(70,205,120),
info=Color3.fromRGB(80,150,255),
warning=Color3.fromRGB(255,186,55),
error=Color3.fromRGB(255,80,70),
risky=Color3.fromRGB(255,90,70),
disabled=Color3.fromRGB(90,94,110),
online=Color3.fromRGB(70,205,120),
offline=Color3.fromRGB(160,160,175),
},

chromium={
topbar=Color3.fromRGB(23,26,38),
topbarIcon=Color3.fromRGB(180,184,200),
topbarHover=Color3.fromRGB(40,44,60),
mac={
close=Color3.fromRGB(255,96,92),
min=Color3.fromRGB(255,190,70),
max=Color3.fromRGB(60,205,105),
},
globalRail=Color3.fromRGB(11,13,19),
},

notification={
toast=Color3.fromRGB(30,33,46),
success=Color3.fromRGB(70,205,120),
info=Color3.fromRGB(80,150,255),
error=Color3.fromRGB(255,80,70),
warning=Color3.fromRGB(255,186,55),
},

overlay={
dialog=Color3.fromRGB(26,29,41),
popup=Color3.fromRGB(30,33,46),
keybox=Color3.fromRGB(30,33,46),
splash=Color3.fromRGB(17,19,27),
dim=0.55,
},

font={
ui=nil,
mono=nil,
sizes={
window_title=16,
subtitle=11,
element_title=14,
desc=12,
label=12,
mono=12,
},
},
}

local e={
name="Light",
base="Dark",
dark=false,

window={
background=c.new({["0"]=Color3.fromRGB(244,246,250),["100"]=Color3.fromRGB(236,239,246)},90),
foreground=Color3.fromRGB(255,255,255),
element=Color3.fromRGB(255,255,255),
sidebar=Color3.fromRGB(243,245,249),
sidebarItem=Color3.fromRGB(255,255,255),
header=Color3.fromRGB(244,246,250),
topbar=Color3.fromRGB(244,246,250),
online=Color3.fromRGB(232,235,242),
rail=Color3.fromRGB(237,240,246),
carry=Color3.fromRGB(255,255,255),
carry2=Color3.fromRGB(255,255,255),
},

text={
window=Color3.fromRGB(28,30,38),
element=Color3.fromRGB(28,30,38),
button=Color3.fromRGB(255,255,255),
slider=Color3.fromRGB(52,55,66),
input=Color3.fromRGB(28,30,38),
dropdown=Color3.fromRGB(28,30,38),
label=Color3.fromRGB(28,30,38),
desc=Color3.fromRGB(110,114,128),
title=Color3.fromRGB(28,30,38),
subtile=Color3.fromRGB(120,124,138),
notification=Color3.fromRGB(28,30,38),
},

stroke={
window=Color3.fromRGB(28,30,38),
element=Color3.fromRGB(28,30,38),
button=Color3.fromRGB(255,255,255),
slider=Color3.fromRGB(255,255,255),
input=Color3.fromRGB(28,30,38),
dropdown=Color3.fromRGB(28,30,38),
sidebar=Color3.fromRGB(28,30,38),
},

rounded={
window=12,
outer=13,
element=6,
button=8,
slider=6,
input=8,
dropdown=8,
colorpicker=4,
notification=12,
dialog=14,
},

scroll={
color=Color3.fromRGB(160,164,178),
transparency=1,
stroke=Color3.fromRGB(255,255,255),
thickness=4,
},

slider={
fill=Color3.fromRGB(255,70,85),
fillTransparency=1,
track=Color3.fromRGB(216,219,228),
stroke=Color3.fromRGB(255,255,255),
thickness=4,
handle=Color3.fromRGB(255,70,85),
},

accent={
color=Color3.fromRGB(255,70,85),
hover=Color3.fromRGB(255,96,109),
active=Color3.fromRGB(226,54,68),
gradient=c.new({["0"]=Color3.fromRGB(255,70,85),["100"]=Color3.fromRGB(255,105,135)},90),
},

status={
success=Color3.fromRGB(28,165,92),
info=Color3.fromRGB(40,120,235),
warning=Color3.fromRGB(200,130,20),
error=Color3.fromRGB(212,60,50),
risky=Color3.fromRGB(255,90,70),
disabled=Color3.fromRGB(180,184,194),
online=Color3.fromRGB(28,165,92),
offline=Color3.fromRGB(140,144,156),
},

chromium={
topbar=Color3.fromRGB(244,246,250),
topbarIcon=Color3.fromRGB(90,94,108),
topbarHover=Color3.fromRGB(230,233,240),
mac={
close=Color3.fromRGB(255,96,92),
min=Color3.fromRGB(255,190,70),
max=Color3.fromRGB(60,205,105),
},
globalRail=Color3.fromRGB(237,240,246),
},

notification={
toast=Color3.fromRGB(255,255,255),
success=Color3.fromRGB(28,165,92),
info=Color3.fromRGB(40,120,235),
error=Color3.fromRGB(212,60,50),
warning=Color3.fromRGB(200,130,20),
},

overlay={
dialog=Color3.fromRGB(255,255,255),
popup=Color3.fromRGB(255,255,255),
keybox=Color3.fromRGB(255,255,255),
splash=Color3.fromRGB(244,246,250),
dim=0.45,
},

font={
ui=nil,
mono=nil,
sizes={
window_title=16,
subtitle=11,
element_title=14,
desc=12,
label=12,
mono=12,
},
},
}


local f={
name="Glass",
base="Dark",
dark=true,

window={
background=c.new({["0"]=Color3.fromRGB(255,255,255),["100"]=Color3.fromRGB(255,255,255)},90),
foreground={r=1,g=1,b=1,a=0.9},
element={r=1,g=1,b=1,a=0.08},
sidebar={r=1,g=1,b=1,a=0.06},
sidebarItem={r=1,g=1,b=1,a=0.1},
header={r=1,g=1,b=1,a=0.06},
topbar={r=1,g=1,b=1,a=0.06},
online={r=1,g=1,b=1,a=0.12},
rail={r=1,g=1,b=1,a=0.08},
carry={r=1,g=1,b=1,a=0.1},
carry2={r=1,g=1,b=1,a=0.16},
},
text=d.text,
stroke=d.stroke,
rounded=d.rounded,
scroll=d.scroll,
slider=d.slider,
accent={
color=Color3.fromRGB(255,70,85),
hover=Color3.fromRGB(255,96,109),
active=Color3.fromRGB(226,54,68),
gradient=c.new({["0"]=Color3.fromRGB(255,70,85),["100"]=Color3.fromRGB(255,105,135)},90),
},
status=d.status,
chromium=d.chromium,
notification={
toast={r=1,g=1,b=1,a=0.85},
success=Color3.fromRGB(70,205,120),
info=Color3.fromRGB(80,150,255),
error=Color3.fromRGB(255,80,70),
warning=Color3.fromRGB(255,186,55),
},
overlay={
dialog={r=1,g=1,b=1,a=0.95},
popup={r=1,g=1,b=1,a=0.9},
keybox={r=1,g=1,b=1,a=0.9},
splash=Color3.fromRGB(17,19,27),
dim=0.35,
},
font=d.font,
}


local g={
name="Mac",
base="Dark",
dark=true,
chrome={buttons="mac"},
windows_background=c.new({["0"]=Color3.fromRGB(13,15,21),["100"]=Color3.fromRGB(20,23,33)},90),
}

b.registry={
Dark=d,
Light=e,
Glass=f,
Mac=g,
}

b.currentName="Dark"
b.current=d





local function clone(h)
local i={}
for j,k in pairs(h)do
if type(k)=="table"then
if isGradient(k)or k.kind=="gradient"then
i[j]=k
else
i[j]=clone(k)
end
else
i[j]=k
end
end
return i
end

function b.Add(h,i)
local j=clone(d)
for k,l in pairs(i)do
if type(l)=="table"and type(j[k])=="table"and not isGradient(l)and l.kind~="gradient"then
for m,n in pairs(l)do
j[k][m]=n
end
else
j[k]=l
end
end
j.name=h
if j.base and b.registry[j.base]and j~=d then

local k=b.registry[j.base]
for l,m in pairs(k)do
if j[l]==nil then
j[l]=clone(m)
end
end
end
b.registry[h]=j
return j
end

local function setCurrent(h)
b.currentName=h
b.current=b.registry[h]or d
end

function b.Get(h)
if h then
setCurrent(h)
end
return b.current
end

function b.List()
local h={}
for i in pairs(b.registry)do
h[#h+1]=i
end
return h
end

function b.Apply(h,i,j)
local k=b.Get(i)
local l=j or 0.2


if b._onApply then
b._onApply(k,l)
end
return k
end

b._onApply=nil


local h={}

function h.resolveColor(i,j,k)
local l=i[j]
if not l then
return Color3.fromRGB(255,255,255)
end
local m=l[k]
if isGradient(m)or(type(m)=="table"and m.kind=="gradient")then
return m.sequence[1].Value,0
end
if typeof(m)=="Color3"then
return m,0
end
if type(m)=="table"and m.r then
return Color3.new(m.r,m.g,m.b),m.a or 0
end
return Color3.fromRGB(255,255,255),0
end

function h.resolve(i,j,k)
local l=i[j]
if not l then
return nil
end
return l[k]
end

b.Resolver=h

return b end function a.c():typeof(__modImpl())local b=a.cache.c if not b then b={c=__modImpl()}a.cache.c=b end return b.c end end do local function __modImpl()





local b={}


local c={
settings="⚙",
sliders="◫",
home="⌂",
user="♟",
users="☰",
scroll="❧",
folder="▤",
file="▧",
copy="❐",
check="✓",
check_circle="◉",
x="✕",
x_circle="⊗",
plus="+",
minus="−",
search="⌕",
bell="◌",
bell_ring="◉",
warning="!",
alert="!",
info="ⓘ",
info_circle="ⓘ",
shield="⛨",
lock="⚿",
unlock="⚿",
eye="◆",
eye_off="◇",
key="⚿",
link="⚯",
external_link="↗",
download="↓",
upload="↑",
copy_link="⧉",
refresh="↻",
trash="🗑",
edit="✎",
pencil="✎",
chevron_right="›",
chevron_left="‹",
chevron_down="⌄",
chevron_up="⌃",
arrow_right="→",
arrow_left="←",
arrow_up="↑",
arrow_down="↓",
chevrons_right="»",
chevrons_left="«",
angle_down="⌄",
close="✕",
maximize="⛶",
minimize="─",
restore="❐",
drag="⠿",
move="✥",
grid="▦",
columns="▤",
stack="▣",
tab="▢",
box="▣",
circle="◯",
square="□",
diamond="◇",
star="★",
heart="♥",
play="▶",
pause="‖",
stop="■",
skip="↠",
fast="»",
music="♪",
film="▣",
camera="■",
image="▧",
image_off="▤",
code="</>",
terminal=">_",
command="⌘",
menu="☰",
more="⋯",
user_plus="♟",
user_check="✓",
badge_check="✔",
verified="✔",
flag="⚑",
tag="✦",
tags="❉",
sparkles="✧",
zap="⚡",
flame="♨",
drop="⬢",
droplet="⬢",
wind="≋",
sun="☀",
moon="☾",
cloud="☁",
clock="◔",
stopwatch="◷",
activity="◉",
pulse="┉",
radio="◉",
signal="◔",
shield_check="⛨",
shield_alert="⛔",
save="⤓",
load="⤒",
export="⤓",
import="⤒",
share="⤴",
discord="▮",
twitter="𝕏",
youtube="▶",
github="⌥",
instagram="◍",
globe="🌐",
message="✉",
mail="✉",
send="↗",
phone="✆",
notebook="▤",
book="▬",
bookmark="▤",
calendar="▤",
event="◔",
history="↺",
timer="◔",
alarm="◉",
battery="▯",
plug="≈",
power="⏻",
settings_2="⚙",
package="□",
layers="▃",
watermark="∂",
filter="▽",
filters="▽",
sort="↕",
table="▥",
rows="▤",
columns_2="▤",
panel="▣",
chat="✉",
comment="✎",
reply="↩",
quote="❝",
hashtag="#",
at="@",
dollar="$",
percent="%",
infinity="∞",
sum="∑",
sigma="∑",
pi="π",
divide="÷",
equal="=",
not_equal="≠",
less="<",
greater=">",
fire="♨",
snow="❆",
rain="≋",
thunder="⚡",
magnet="▰",
hammer="⌑",
axe="⌖",
sword="⚔",
skull="☠",
bug="⊡",
crosshair="◎",
target="◎",
sports="⚽",
game="◤",
joystick="⚉",
controller="⚉",
crown="♛",
trophy="⚶",
medal="✦",
award="✦",
certificate="✦",
upload_cloud="↑",
download_cloud="↓",
server="▯",
database="▤",
hard_drive="▯",
cpu="▦",
memory="▨",
wifi="≋",
bluetooth="ᛒ",
nfc="◍",
qr="▣",
barcode="▮",
key_round="⚿",
vault="⚿",
scan="◫",
frame="▢",
focus="◎",
zoom_in="⍐",
zoom_out="⍗",
mouse="🖰",
pointer="➤",
cursor="➤",
hand="☞",
touch="✚",
gesture="✚",
waves="≋",
waveform="┉",
audio="♪",
mute="🜏",
volume="♪",
volume_off="🜏",
mic="♩",
mic_off="♩",
video="▶",
video_off="⊘",
camera_off="⊘",
monitor="▭",
laptop="▭",
smartphone="▯",
tablet="▯",
watch="◷",
glasses="◫",
feather="✒",
pen="✎",
mouse_click="🖰",
text="▤",
text_cursor="❐",
align_left="▤",
align_center="▤",
align_right="▤",
bold="B",
italic="I",
underline="U",
strikethrough="S",
list="▰",
list_ordered="1.",
brackets="()",
braces="{}",
parentheses="()",
quote_close="❞",
full_screen="⛶",
expand="⛶",
collapse="⛶",
compass="◎",
map="▤",
map_pin="⚲",
pin="⚲",
location="⚲",
road="▬",
poop="☺",
smile="☺",
frown="☹",
meh="–",
laugh="☺",
cry="☹",
angry="☹",
tongue="☺",
wink="☺",
sleep="☾",
coffee="☕",
pizza="⌾",
burger="▦",
sandwich="▧",
fish="〈",
chicken="◔",
beef="▥",
apple="❆",
leaf="❦",
flower="❀",
cherry="◉",
grape="◉",
lemon="◉",
orange="◉",
watermelon="◉",
bolt="⚡",
plug_zap="≈",
socket="▭",
radio_tower="◬",
antenna="◬",
satellite="⌾",
rocket="☄",
plane="✈",
train="▬",
car="▭",
truck="▭",
bike="⚲",
bus="▭",
ship="⌾",
anchor="⚓",
life_buoy="◎",
crosshair_2="◎",
rotate="↻",
rotate_ccw="↺",
flip="↔",
undo="↶",
redo="↷",
shuffle="↔",
["repeat"]="↻",
repeat_1="↻",
random="↔",
cast="⌸",
share_2="⤴",
link_2="⧉",
unlink="⧄",
link_2_off="⧄",
git_branch="╾",
git_commit="◇",
git_pull="⌥",
git_merge="⌥",
github_2="⌥",
}

local function nameToGlyph(d)
if type(d)~="string"then
return nil
end
local e=d:lower():gsub("-","_"):gsub(" ","_")
return c[e]
end

b.nameToGlyph=nameToGlyph
b.GLYPHS=c



b.toRich=function(d,e)
if d==nil then
return nil
end
if type(d)=="string"then
local f=nameToGlyph(d)
if f then
return'<font size="'..(e or 13)..'">'..f.."</font>"
end
return nil
end
if type(d)=="table"and d.glyph then
return'<font size="'..(d.size or e or 13)..'">'..d.glyph.."</font>"
end
return nil
end

return b end function a.d():typeof(__modImpl())local b=a.cache.d if not b then b={c=__modImpl()}a.cache.d=b end return b.c end end do local function __modImpl()




local b=a.a()
local c=a.c()
local d=a.d()

local e={}

e.Theme=c



local function applyStyle(f,g,h,i,j,k)
local l=i or c.Get"Dark"
local m=l[g]and l[g][h]
if m==nil then
return
end
local n=type(m)=="table"and(m.kind=="gradient"or m["0"]~=nil or m[0]~=nil)

local function apply(o)
if n then
local p=m.kind=="gradient"and m or c.Gradient.new(m,m.rotation)
local q=c.Gradient.toSequence(p)
local r=o:FindFirstChildOfClass"UIGradient"
if r then
if k and k>0 then
b.tween(r,TweenInfo.new(k,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{
Color=q,
})
else
r.Color=q
end
else
local s=Instance.new"UIGradient"
s.Color=q
s.Rotation=p.rotation or 90
s.Parent=o
end
o.BackgroundTransparency=0
else
local p,q=c.Resolver.resolveColor(l,g,h)
if k and k>0 then
b.tween(o,TweenInfo.new(k,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{
BackgroundColor3=p,
BackgroundTransparency=q,
})
else
o.BackgroundColor3=p
o.BackgroundTransparency=q
end
end
end

if j then
apply(j)


end
end


function e.applyTheme(f,g,h)
local i=f:GetDescendants()
for j,k in ipairs(i)do
if k:IsA"GuiObject"then
local l=k:GetAttribute"KronosBlock"
local m=k:GetAttribute"KronosKey"
if l and m then
local n=g local o=
n[l]and n[l][m]
applyStyle(k,l,m,n,k,h)
end
end
end
end


local function bindTheme(f,g,h)
f:SetAttribute("KronosBlock",g)
f:SetAttribute("KronosKey",h)
end

e.bindTheme=bindTheme

local function roundRect(f,g)
local h=Instance.new"UICorner"
h.CornerRadius=UDim.new(0,g or 6)
h.Parent=f
end

e.roundRect=roundRect




function e.Frame(f,g)
g=g or{}
local h=Instance.new"Frame"
h.Name=g.name or"KronosFrame"
h.Size=g.size or UDim2.fromScale(1,1)
h.Position=g.position or UDim2.fromOffset(0,0)
h.AnchorPoint=g.anchor or Vector2.new(0,0)
h.BackgroundTransparency=g.transparency or 0
h.BackgroundColor3=g.color or c.Resolver.resolveColor(c.Get"Dark","window","foreground")
h.BorderSizePixel=0
h.ClipsDescendants=g.clips==nil and true or g.clips
if g.zIndex then
h.ZIndex=g.zIndex
end
if g.visible==false then
h.Visible=false
end

h.Active=g.active or false
if g.ignoreMouse then
h.Active=false
h.Selectable=false
end
if g.block then
bindTheme(h,g.block,g.key or"element")
end
if g.restrictToSibling then
h:SetAttribute("RestrictToSibling",g.restrictToSibling)
end
h.Parent=f
return h
end




function e.Label(f,g)
g=g or{}
local h=Instance.new"TextLabel"
h.Name=g.name or"KronosLabel"
h.Size=g.size or UDim2.fromScale(1,1)
h.Position=g.position or UDim2.fromOffset(0,0)
h.AnchorPoint=g.anchor or Vector2.new(0,0)
h.BackgroundTransparency=1
h.BorderSizePixel=0
h.Text=g.text or""
h.TextColor3=g.color or c.Resolver.resolveColor(c.Get"Dark","text","label")
h.TextTransparency=g.textTransparency or 0
h.Font=g.font or Enum.Font.Code
if g.enumFont then
h.Font=g.enumFont
end
h.TextSize=g.textSize or 14
h.TextXAlignment=g.x or Enum.TextXAlignment.Left
h.TextYAlignment=g.y or Enum.TextYAlignment.Center
h.TextWrapped=g.wrap or false
h.RichText=g.rich or false
h.ClipsDescendants=g.clips or false
if g.zIndex then
h.ZIndex=g.zIndex
end
if g.visible==false then
h.Visible=false
end
if g.block then
bindTheme(h,g.block,g.key or"label")
end
h.Parent=f
return h
end




function e.Button(f,g)
g=g or{}
local h=Instance.new"TextButton"
h.Name=g.name or"KronosButton"
h.Size=g.size or UDim2.fromScale(1,1)
h.Position=g.position or UDim2.fromOffset(0,0)
h.AnchorPoint=g.anchor or Vector2.new(0,0)
h.BackgroundTransparency=g.transparency or 0
h.BorderSizePixel=0
h.Text=g.text or""
h.TextColor3=g.color or c.Resolver.resolveColor(c.Get"Dark","text","button")
h.TextTransparency=g.textTransparency or 0
h.Font=g.font or Enum.Font.Code
h.TextSize=g.textSize or 14
h.TextXAlignment=g.x or Enum.TextXAlignment.Center
h.TextYAlignment=g.y or Enum.TextYAlignment.Center
h.RichText=g.rich or false
h.AutoButtonColor=false
h.ClipsDescendants=g.clips or false
if g.zIndex then
h.ZIndex=g.zIndex
end
if g.block then
bindTheme(h,g.block,g.key or"element")
end

if g.hover then
local i=h.BackgroundColor3
local j=g.hover
h.MouseEnter:Connect(function()
b.tween(h,TweenInfo.new(0.1),{BackgroundColor3=j})
end)
h.MouseLeave:Connect(function()
b.tween(h,TweenInfo.new(0.1),{BackgroundColor3=i})
end)
end
if g.visible==false then
h.Visible=false
end
h.Parent=f
return h
end




function e.create(f,g,h)
h=h or{}
local i=Instance.new(f)
i.Name=h.name or f
i.Size=h.size
i.Position=h.position
i.AnchorPoint=h.anchor
if h.zIndex then
i.ZIndex=h.zIndex
end
if h.visible==false then
i.Visible=false
end
i.Parent=g
return i
end




function e.Scroll(f,g)
g=g or{}
local h=Instance.new"ScrollingFrame"
h.Name=g.name or"KronosScroll"
h.Size=g.size or UDim2.fromScale(1,1)
h.Position=g.position or UDim2.fromOffset(0,0)
h.AnchorPoint=g.anchor or Vector2.new(0,0)
h.BackgroundTransparency=g.transparency or 1
h.BackgroundColor3=g.color
h.BorderSizePixel=0
h.ScrollBarThickness=g.thickness or 4
h.ScrollBarTransparency=g.barTransparency or 0.8
h.CanvasSize=g.canvasSize or UDim2.fromScale(1,1)
h.AutomaticCanvasSize=g.auto or Enum.AutomaticSize.Y
h.ScrollingDirection=g.direction or Enum.ScrollingDirection.Y
h.ScrollBarImageColor3=g.barImage or c.Resolver.resolveColor(c.Get"Dark","scroll","color")
if g.zIndex then
h.ZIndex=g.zIndex
end
if g.visible==false then
h.Visible=false
end
h.Parent=f
return h
end




function e.IconLabel(f,g)
g=g or{}
local h=g.icon
local i=d.nameToGlyph(h)
if g.imageId and not g.forceGlyph then
local j=Instance.new"ImageLabel"
j.Image=g.imageId
j.ImageColor3=g.color or c.Resolver.resolveColor(c.Get"Dark","chromium","topbarIcon")
j.Size=g.size or UDim2.fromOffset(14,14)
j.BackgroundTransparency=1
j.Parent=f
return j
end
local j=e.Label(f,{
name=g.name or"Icon",
size=g.size or UDim2.fromOffset(14,14),
textSize=g.textSize or 12,
text=i or"",
color=g.color or c.Resolver.resolveColor(c.Get"Dark","chromium","topbarIcon"),
x=Enum.TextXAlignment.Center,
y=Enum.TextYAlignment.Center,
})
return j
end

e.applyStyle=applyStyle

return e end function a.e():typeof(__modImpl())local b=a.cache.e if not b then b={c=__modImpl()}a.cache.e=b end return b.c end end do local function __modImpl()



local b=a.e()
local c=a.c()a.a()


local d={}

local function styled(e,f)

local g=b.Frame(e,{
name=f.name,
size=f.size,
position=f.position,
block=f.block,
key=f.key,
transparency=f.transparency,
color=f.color,
clips=f.clips,
zIndex=f.zIndex,
})
if f.radius then
b.roundRect(g,f.radius)
end
return g
end


local function makeListLayout(e,f)
f=f or{}
local g=Instance.new"UIListLayout"
g.Name="KronosList"
g.SortOrder=Enum.SortOrder.LayoutOrder
g.FillDirection=f.direction or Enum.FillDirection.Vertical
g.HorizontalAlignment=f.xAlign or Enum.HorizontalAlignment.Left
g.VerticalAlignment=f.yAlign or Enum.VerticalAlignment.Top
g.Padding=UDim.new(0,f.padding or 8)
if f.horizontalFlex then
g.HorizontalFlex=f.horizontalFlex
end
g.Parent=e
end
d.makeListLayout=makeListLayout


function d.ElementList(e,f)
f=f or{}
local g=b.Scroll(e,{
name=f.name or"ElementList",
size=f.size or UDim2.fromScale(1,1),
transparency=1,
thickness=f.thickness or 4,
barImage=c.Resolver.resolveColor(c.Get(c.currentName or"Dark"),"scroll","color"),
})
local h=b.Frame(g,{
name="Holder",
size=UDim2.new(1,0,0,0),
transparency=1,
clips=false,
})
local i=makeListLayout(h,{padding=f.padding or 8})


local function refreshCanvas()
local j=h.AbsoluteSize.Y
g.CanvasSize=UDim2.fromOffset(0,j+(f.pad or 0))
end
local function onChild()
coroutine.wrap(function()
task.wait()
refreshCanvas()
end)()
end
h.ChildAdded:Connect(onChild)
h.ChildRemoved:Connect(onChild)
h:GetPropertyChangedSignal"AbsoluteSize":Connect(onChild)
task.spawn(onChild)

return{
Root=g,
Holder=h,
Layout=i,
Add=function(j,k)
j.LayoutOrder=k or#h:GetChildren()
j.Parent=h
return j
end,
Insert=function(j,k)
local l=h:GetChildren()
local m=0
for n,o in ipairs(l)do
if o:IsA"GuiObject"and o~=i then
m=m+1
end
end
k=math.clamp(k or(m+1),1,m+1)
for n,o in ipairs(l)do
if o:IsA"GuiObject"and o~=i and o.LayoutOrder>=k then
o.LayoutOrder=o.LayoutOrder+1
end
end
j.LayoutOrder=k
j.Parent=h
end,
Clear=function()
for j,k in ipairs(h:GetChildren())do
if k:IsA"GuiObject"then
k:Destroy()
end
end
end,
Visible=function(j)
g.Visible=j
end,
}
end


function d.Section(e,f)
f=f or{}
local g={}
local h=styled(e,{
name=f.name or"Section",
size=UDim2.new(1,0,0,0),
transparency=1,
clips=false,
zIndex=f.zIndex or 2,
})
g.Root=h
g.Add=function(i,j)
i.LayoutOrder=j
i.Parent=h
return i
end
return g
end


function d.Groupbox(e,f)
f=f or{}
local g=f.radius or 8
local h=styled(e,{
name=f.name or"Groupbox",
size=UDim2.new(1,0,0,0),
block="window",
key="element",
transparency=f.transparency or 0,
zIndex=f.zIndex or 2,
})
b.roundRect(h,g)
if f.border then
local i=Instance.new"UIStroke"
i.Color=c.Resolver.resolveColor(c.Get"Dark","stroke","window")
i.Transparency=0.75
i.Thickness=1
i.Parent=h
end

local i
if f.title then
i=b.Label(h,{
name="Title",
size=UDim2.new(1,-24,0,24),
position=UDim2.fromOffset(12,6),
text=f.title,
textSize=14,
color=c.Resolver.resolveColor(c.Get"Dark","text","title"),
font=Enum.Font.Code,
})
end

local j=b.Frame(h,{
name="Stack",
size=UDim2.new(1,-24,0,0),
position=UDim2.fromOffset(12,i and 34 or 12),
transparency=1,
clips=false,
})
local k=Instance.new"UIListLayout"
k.Name="KronosList"
k.SortOrder=Enum.SortOrder.LayoutOrder
k.Padding=UDim.new(0,6)
k.Parent=j

local function refreshHeight()
local l=j.AbsoluteSize.Y+(i and 40 or 14)
h.Size=UDim2.new(1,0,0,l+6)
end
j.ChildAdded:Connect(function()
task.defer(refreshHeight)
end)
j:GetPropertyChangedSignal"AbsoluteSize":Connect(function()
task.defer(refreshHeight)
end)

local l={
Root=h,
Stack=j,
Layout=k,
Add=function(l,m)
l.LayoutOrder=m
l.Parent=j
task.defer(refreshHeight)
return l
end,
SetTitle=function(l)
if i then
i.Text=l
end
end,
Clear=function()
for l,m in ipairs(j:GetChildren())do
if m:IsA"GuiObject"then
m:Destroy()
end
end
end,
}
return l
end

return d end function a.f():typeof(__modImpl())local b=a.cache.f if not b then b={c=__modImpl()}a.cache.f=b end return b.c end end do local function __modImpl()



local b=a.a()

local c={}

local d=b.UserInputService

local function isOver(e,f)
if not f then
return false
end
local g,h=e.AbsolutePosition,e.AbsoluteSize
return f.X>=g.X
and f.X<=g.X+h.X
and f.Y>=g.Y
and f.Y<=g.Y+h.Y
end

local function applyStyle(e,f)

if not e then
return
end
local g=e:FindFirstChild"KronosDragHandle"
if g then
if f==2 then
g.Visible=true
else
g.Visible=false
end
end
end

c.applyStyle=applyStyle



function c.attach(e)
local f=e.handle
local g=e.root
local h=e.minSize or Vector2.new(520,360)
local i=e.maxSize or Vector2.new(900,620)
local j={}
local k={}

local l=false

local function beginDrag()
j.started=true
j.startMouse=d:GetMouseLocation()
j.startPos=g.Position
end

local function beginResize(m)
k.started=true
k.edge=m
k.startMouse=d:GetMouseLocation()
k.startSize=g.Size
k.startPos=g.Position
end


d.InputBegan:Connect(function(m,n)
if n then
return
end
if m.UserInputType==Enum.UserInputType.MouseButton1 then
local o=d:GetMouseLocation()
if isOver(f,o)then
beginDrag()
end
l=true
end
end)

d.InputEnded:Connect(function(m,n)
if n then
return
end
if m.UserInputType==Enum.UserInputType.MouseButton1 then
j.started=false
k.started=false
l=false
end
end)

d.InputChanged:Connect(function(m,n)
if n then
return
end
if m.UserInputType==Enum.UserInputType.MouseMovement then
local o=d:GetMouseLocation()

if e.resizable then
local p,q=g.AbsoluteSize.X,g.AbsoluteSize.Y
local r,s=o.X-g.AbsolutePosition.X,o.Y-g.AbsolutePosition.Y
local t
if r>=p-6 and s>=q-6 then
t="se"
elseif r<=6 and s>=q-6 then
t="sw"
elseif r>=p-6 and s<=6 then
t="ne"
elseif r<=6 and s<=6 then
t="nw"
elseif r>=p-6 then
t="e"
elseif r<=6 then
t="w"
elseif s>=q-6 then
t="s"
elseif s<=6 then
t="n"
end
if t and l then
beginResize(t)
end
end
end
end)

d.InputChanged:Connect(function(m,n)
if n then
return
end
if m.UserInputType==Enum.UserInputType.MouseMovement and j.started and not k.started then
local o=d:GetMouseLocation()-j.startMouse
local p=j.startPos+UDim2.fromOffset(o.X,o.Y)
g.Position=p
if e.posCallback then
e.posCallback(p)
end
end

if m.UserInputType==Enum.UserInputType.MouseMovement and k.started then
local o=d:GetMouseLocation()-k.startMouse
local p=k.startSize+UDim2.fromOffset(o.X,o.Y)
local q=k.startPos
local r=k.edge

if r:find"w"then
p=p-UDim2.fromOffset(o.X,0)
q=q+UDim2.fromOffset(o.X,0)
end
if r:find"n"then
p=p-UDim2.fromOffset(0,o.Y)
q=q+UDim2.fromOffset(0,o.Y)
end

local s=p.X.Offset
local t=p.Y.Offset
s=math.clamp(s,h.X,i.X)
t=math.clamp(t,h.Y,i.Y)
p=UDim2.fromOffset(s,t)
g.Size=p
g.Position=q
if e.posCallback then
e.posCallback(q)
end
if e.sizeCallback then
e.sizeCallback(p,q)
end
end
end)


d.TouchMoved:Connect(function(m)
if j.started and not k.started then
local n=m.Delta
g.Position=g.Position+UDim2.fromOffset(n.X,n.Y)
end
end)

function e.RefreshDragHandle(m)
applyStyle(j.folder,e.dragStyle)
end


function e.DestroyDrag(m)
j.started=false
k.started=false
end

return{
beginDrag=beginDrag,
beginResize=beginResize,
isOver=isOver,
}
end

return c end function a.g():typeof(__modImpl())local b=a.cache.g if not b then b={c=__modImpl()}a.cache.g=b end return b.c end end do local function __modImpl()



local b={}
b.__index=b

local c={}
local d="en"

local e={settings=
"Settings",config=
"Config",home=
"Home",search=
"Search...",search_placeholder=
"Search...",no_results=
"No results",copy=
"Copy",copied=
"Copied!",discord=
"Discord",key=
"Key",key_enter=
"Enter your key",key_verify=
"Verify",key_save=
"Save key",key_copy_link=
"Copy key",key_offline=
"Offline",key_offline_help=
"Could not reach key server.",done=
"Done",cancel=
"Cancel",close=
"Close",ok=
"OK",yes=
"Yes",no=
"No",change=
"CHANGELOG",version=
"Version",loading=
"Loading...",supported=
"Supported executors:",not_found=
"Not found",unsaved=
"Unsaved",save=
"Save",load=
"Load",delete=
"Delete",export=
"Export",import=
"Import",pin=
"Pin",minimize=
"Minimize",maximize=
"Maximize",restore=
"Restore",clear=
"Clear",filter=
"Filter",all=
"All",none=
"None",on=
"On",off=
"Off",enabled=
"Enabled",disabled=
"Disabled",pinned=
"Pinned",drag=
"Drag",resize=
"Resize",click_to_open=
"Open",never=
"Never",always=
"Always",hold=
"Hold",toggle=
"Toggle",bind=
"None",listening=
"...",custom=
"Custom",default=
"Default",
}

c.en=e

local f={}
f.en=e


f.es={}
f.de={}
f.fr={}
f.pt={}
f.ru={}

local function initDicts()

for g,h in pairs(f)do
if h~=e then

for i,j in pairs(e)do
if h[i]==nil then
h[i]=j
end
end
end
end
end
initDicts()

function b.setLanguage(g)
if f[g]then
d=g
if b.onLanguageChanged then
pcall(b.onLanguageChanged,g)
end
return true
end
return false
end

function b.getLanguage()
return d
end

function b.addLanguage(g,h)
f[g]=h or{}
initDicts()
return true
end


function b.t(g,h)
local i=g
local j=h
if h==nil then
i=d
j=g
end
local k=f[i]or f.en or e
return k[j]or e[j]or j
end


function b.localize(g,h)
if type(g)=="string"and g:sub(1,4)=="loc:"then
return b.t(h or d,g:sub(5))
end
return g
end

b.available=c
b.onLanguageChanged=nil

return b end function a.h():typeof(__modImpl())local b=a.cache.h if not b then b={c=__modImpl()}a.cache.h=b end return b.c end end do local function __modImpl()




local b={}
b.entries={}

local function normalize(c)
return tostring(c or"")
end

function b.register(c)
if not c or not c.name then
return
end
local d=c.name
if c.flag and c.flag~=""then
d=c.flag
end
b.entries[d]=c
end

function b._set(c)
for d,e in pairs(c)do
b.entries[d]=e
end
end

b.normId=normalize
b.unregister=function(c)
b.entries[c]=nil
end

b.get=function(c)
return b.entries[c]
end

b.all=function()
return b.entries
end

b.clear=function()
b.entries={}
end

return b end function a.i():typeof(__modImpl())local b=a.cache.i if not b then b={c=__modImpl()}a.cache.i=b end return b.c end end do local function __modImpl()




local b=a.e()
local c=a.c()a.a()

local d=a.d()
local e=a.h()

local f={}

local function el(g,h,i)
i=i or{}
return{
name=g,
type=i.type or"Element",
Instance=h,
Root=h,
}
end





function f.bind(g)

g._destroyCallbacks={}
g._visibleWhen=nil

function g.SetTitle(h,i)
g.title=i
if g.TitleLabel then
g.TitleLabel.Text=i
end
end

function g.SetDesc(h,i)
g.desc=i
if g.DescLabel then
g.DescLabel.Text=i
end
end

function g.SetIcon(h,i)
g.icon=i
if g.IconObj then
local j=d.toRich(i)
if j then
g.IconObj.Text=j
end
end
end

function g.SetValue(h,i,j)
if g.value~=nil and g._setValue then
g:_setValue(i,j)
end
end

function g.GetValue(h)
return g.value
end

function g.Set(h,i,j)

if g._setValue then
g:_setValue(i,j)
end
return g
end

function g.OnChanged(h,i)
g._onChanged=i
if g.ValueSource then
g.ValueSource:Changed(i)
end
return g
end

function g.GetChanged(h)
if g.ValueSource then
return g.ValueSource.Changed
end
return nil
end

function g.Lock(h,i)
g._locked=i or true
if g.Root then
g.Root:SetAttribute("KronosLocked",true)
end
if g._setLocked then
g:_setLocked(true,i)
end
return g
end

function g.Unlock(h)
g._locked=nil
if g.Root then
g.Root:SetAttribute("KronosLocked",nil)
end
if g._setLocked then
g:_setLocked(false)
end
return g
end

function g.IsLocked(h)
return not not g._locked
end

function g.VisibleWhen(h,i,j,k)

if type(i)=="table"then
j=i.equals
k=i.element
i=i.flag
end
g._visibleWhen={flag=i,equals=j,element=k}
g:_evaluateVisible()
return g
end

function g._evaluateVisible(h)
local i=g._visibleWhen
if not i then
return
end
local j=true
local k=i.element
if not k then

local l=a.i()
k=l.get(i.flag)
end
if k then
local l=k.value
if i.equals~=nil then
j=l==i.equals
else
j=not not l
end
end
g.Instance.Visible=j
end

function g.AddToVisibilityPool(h,i,j)

local function reEval()
g:_evaluateVisible()
end
if j then
if j._visibilityHooks then
j._visibilityHooks[#j._visibilityHooks+1]=reEval
end
end
end

function g.MoveTo(h,i)

local j=g.Instance.Parent
if j then
local k=j:FindFirstChild"KronosList"
local l={}
for m,n in ipairs(j:GetChildren())do
if n:IsA"GuiObject"and n~=k then
l[#l+1]=n
end
end
i=math.clamp(i or 1,1,#l)
local m=1
for n,o in ipairs(l)do
if o==g.Instance then
continue
end
if m==i then
m=m+1
end
o.LayoutOrder=m
m=m+1
end
g.Instance.LayoutOrder=i
end
end

function g.MoveToTop(h)
g:MoveTo(1)
end

function g.MoveToBottom(h)
g:MoveTo(math.huge)
end

function g.MoveToUp(h)
local i=g.Instance.LayoutOrder or 1
g:MoveTo(math.max(1,i-1))
end

function g.MoveToDown(h)
local i=g.Instance.LayoutOrder or 0
g:MoveTo(i+1)
end

function g.Show(h)
g.Instance.Visible=true
end

function g.Hide(h)
g.Instance.Visible=false
end

function g.toggleVisibility(h)
g.Instance.Visible=not g.Instance.Visible
end

function g.AddOnDestroy(h,i)
g._destroyCallbacks[#g._destroyCallbacks+1]=i
end

function g.Destroy(h)
for i,j in ipairs(g._destroyCallbacks)do
pcall(j)
end
if g.Root and g.Root.Destroy then
g.Root:Destroy()
end
if g.ValueSource then
g.ValueSource:Destroy()
end
end
end



local function row(g,h,i)
i=i or 40
local j=b.Frame(g,{
name=h.name or"Row",
size=UDim2.new(1,0,0,i),
block="window",
key="element",
transparency=0,
clips=false,
})
b.roundRect(j,h.radius or 6)

local k=b.Frame(j,{
name="Inner",
size=UDim2.new(1,-16,1,-8),
position=UDim2.fromOffset(8,4),
transparency=1,
clips=false,
})

local l
if h.icon then
local m=d.toRich(h.icon,13)
if m then
l=b.Label(k,{
name="Icon",
size=UDim2.fromOffset(18,i-8),
anchor=Vector2.new(0,0.5),
text=m,
rich=true,
textSize=13,
x=Enum.TextXAlignment.Center,
color=c.Resolver.resolveColor(c.Get"Dark","accent","color"),
})
end
end

local m=0
local n=l and UDim2.fromOffset(26,0)or UDim2.fromOffset(4,0)
if h.icon then
m=26
end

local o=b.Label(k,{
name="Title",
size=UDim2.new(1,-(h.desc and 60 or 100+m),0,i-8),
position=n,
anchor=Vector2.new(0,0.5),
text=e.localize(h.title or h.name or""),
textSize=h.titleSize or 14,
color=c.Resolver.resolveColor(c.Get"Dark","text","element"),
font=h.font or Enum.Font.Code,
x=Enum.TextXAlignment.Left,
})

local p
if h.desc then
p=b.Label(j,{
name="Desc",
size=UDim2.new(1,-16,0,14),
position=UDim2.fromOffset(12,i-16),
text=e.localize(h.desc),
textSize=12,
color=c.Resolver.resolveColor(c.Get"Dark","text","desc"),
font=Enum.Font.SourceSans,
x=Enum.TextXAlignment.Left,
})
end

local q=b.Frame(k,{
name="Right",
size=UDim2.new(0,h.rightWidth or 100,1,0),
position=UDim2.new(1,0,0,0),
anchor=Vector2.new(1,0),
transparency=1,
clips=false,
})

return{
root=j,
inner=k,
title=o,
desc=p,
icon=l,
right=q,
}
end

f.row=row
f.bind=bind
f.el=el

return f end function a.j():typeof(__modImpl())local b=a.cache.j if not b then b={c=__modImpl()}a.cache.j=b end return b.c end end do local function __modImpl()





local b=a.a()

local c={}


local function keyCodeFromNumber(d)
if type(d)~="number"then
return nil
end
local e,f=pcall(function()
return Enum.KeyCode[d]
end)
if e and f then
return f
end
return nil
end

function c.parseKey(d)
if typeof(d)=="EnumItem"then
return d
end
if type(d)=="number"then
local e,f=pcall(function()
return Enum.KeyCode[d]
end)
if e and f then
return f
end
end
if type(d)=="table"and d.UserInputType then
return d
end
return nil,"no such key"
end

function c.parseUserInput(d)



if typeof(d)=="Instance"then
if d:IsA"InputObject"then
local e,f=pcall(function()
local e=d.UserInputType
if e.Name:match"MouseButton"or d.KeyCode==Enum.KeyCode.Unknown then
return{
kind="mouse",
inputType=e,
id=e.Name,
}
end
return{
kind="key",
keyCode=d.KeyCode,
id=d.KeyCode.Name,
}
end)
if e then
return f
end
return nil
end
end
if typeof(d)=="EnumItem"then
if d.EnumType==Enum.UserInputType then
return{kind="mouse",inputType=d,id=d.Name}
end
return{kind="key",keyCode=d,id=d.Name}
end
local e=c.parseKey(d)
if e and typeof(e)=="EnumItem"then
return{kind="key",keyCode=e,id=e.Name}
end
return nil
end


local d={
MouseButton1="Left Click",
MouseButton2="Right Click",
MouseButton3="Middle Click",
MouseButton4="Mouse 4",
MouseButton5="Mouse 5",
Button6="Mouse 6",
MouseWheel="Mouse Wheel",
}

local e={
Zero="0",
One="1",
Two="2",
Three="3",
Four="4",
Five="5",
Six="6",
Seven="7",
Eight="8",
Nine="9",
}

function c.prettyName(f)
local g
if typeof(f)=="EnumItem"then
g=f.Name
elseif type(f)=="number"then
local h=keyCodeFromNumber(f)
if h then
g=h.Name
end
end
if type(g)~="string"then
return"None"
end
if d[g]then
return d[g]
end
if e[g]then
return e[g]
end

return g:gsub("(%l)(%u)","%1 %2"):gsub("KeyPad","Keypad")
end



local function newKeybindState(f)
f=f or{}
local g={
mode=f.mode or"always",
key=f.default or f.key,
parsed=c.parseUserInput(f.default),
toggled=false,
down=false,
callback=f.callback,
clickCallback=f.clickCallback,
onKeyChanged=f.onKeyChanged,
onToggleChanged=f.onToggleChanged,
}
local h=b.UserInputService

local function keyMatches(i)
if not i or not g.parsed then
return false
end
return i.kind==g.parsed.kind and i.id==g.parsed.id
end

g.InputBegan=h.InputBegan:Connect(function(i,j)
if j then
return
end
local k=c.parseUserInput(i)
if not k then
return
end
if keyMatches(k)then
g.down=true
if g.mode=="hold"then
if g.callback then
g.callback(true,i)
end
g.toggled=true
if g.onToggleChanged then
g.onToggleChanged(true)
end
elseif g.mode=="toggle"then

else

if g.callback then
g.callback(false,i)
end
end
if g.clickCallback then
g.clickCallback(i,g)
end
end
end)

g.InputEnded=h.InputEnded:Connect(function(i,j)
if j then
return
end
local k=c.parseUserInput(i)
if not k then
return
end
if keyMatches(k)then
g.down=false
if g.mode=="hold"then
g.toggled=false
if g.callback then
g.callback(false,i)
end
if g.onToggleChanged then
g.onToggleChanged(false)
end
elseif g.mode=="toggle"then
g.toggled=not g.toggled
if g.callback then
g.callback(g.toggled,i)
end
if g.onToggleChanged then
g.onToggleChanged(g.toggled)
end
end
end
end)

function g.SetKey(i,j)
local k=c.parseUserInput(j)
g.parsed=k
g.key=j
if g.onKeyChanged then
g.onKeyChanged(j)
end
end

function g.GetKey(i)
if g.parsed then
return g.parsed.id
end
return g.key
end

function g.GetState(i)
return g.toggled
end

function g.Destroy(i)
g.InputBegan:Disconnect()
g.InputEnded:Disconnect()
end

return g
end

c.newKeybindState=newKeybindState

return c end function a.k():typeof(__modImpl())local b=a.cache.k if not b then b={c=__modImpl()}a.cache.k=b end return b.c end end do local function __modImpl()





local b=a.j()
local c=a.e()
local d=a.c()
local e=a.a()
local f=a.d()
local g=a.b()
local h=a.k()

local i={}

local function theme()
return d.Get(d.currentName or"Dark")
end























function i.Button(j)
local k=j.opts or{}
local l=j.parent
local m=k.style or"default"

local n=b.row(l,k,k.height or 40)
local o=c.Button(n.inner,{
name="Button",
size=UDim2.new(1,0,1,0),
text=k.text or k.title or"Button",
textSize=14,
zIndex=3,
transparency=0,
color=m=="primary"and theme().accent.color or(m=="destructive"and theme().status.error or theme().window.element),
hover=m=="primary"and theme().accent.hover or(m=="destructive"and theme().status.error or theme().window.carry2),
block="window",
key="element",
})
c.roundRect(o,6)
if m=="default"then
o.BackgroundColor3=theme().window.element
o.BackgroundTransparency=0
end

local p=false
local q={
name=k.name or k.title or"Button",
type="Button",
Instance=n.root,
Root=n.root,
TitleLabel=n.title,
DescLabel=n.desc,
}
b.bind(q)

o.MouseButton1Click:Connect(function()
if p then
return
end
if k.callback then
local r,s=pcall(k.callback)
if not r then
warn("[Kronos] Button callback error:",s)
end
end
end)

function q.Set(r,s)
o.Text=s
end

function q._setLocked(r,s)
p=s
if s then
o.BackgroundTransparency=0
o.BackgroundColor3=theme().status.disabled
else
o.BackgroundColor3=m=="primary"and theme().accent.color or theme().window.element
end
end

return q
end

i.ButtonGroup=function(j)
return i.Button(j)
end




function i.Toggle(j)
local k=j.opts or{}
local l=j.parent
local m=k.variant or"checkbox"

local n=b.row(l,k,k.height or 40)
local o=n.right

local p=g.new(k.default or false)
local q
local r
local s

if m=="switch"then
q=c.Button(o,{
name="Track",
size=UDim2.fromOffset(44,22),
anchor=Vector2.new(1,0.5),
transparency=0,
color=theme().window.carry2,
block="window",
key="carry2",
zIndex=3,
})
c.roundRect(q,11)
r=c.Frame(q,{
name="Knob",
size=UDim2.fromOffset(18,18),
position=UDim2.fromOffset(2,2),
transparency=0,
color=theme().text.label,
clips=false,
})
c.roundRect(r,9)

local function setKnob(t)
if t then
e.tween(r,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=UDim2.fromOffset(24,2)})
e.tween(q,TweenInfo.new(0.15),{BackgroundColor3=theme().accent.color})
else
e.tween(r,TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=UDim2.fromOffset(2,2)})
e.tween(q,TweenInfo.new(0.15),{BackgroundColor3=theme().window.carry2})
end
end
setKnob(p:Get())
q.MouseButton1Click:Connect(function()
if handle._locked then
return
end
p:Set(not p:Get())
end)
else
s=c.Button(o,{
name="Box",
size=UDim2.fromOffset(22,22),
anchor=Vector2.new(1,0.5),
text="",
transparency=0,
color=theme().window.carry2,
block="window",
key="carry2",
zIndex=3,
})
c.roundRect(s,6)
local t=c.Label(s,{
name="Check",
size=UDim2.fromScale(1,1),
text="✓",
textSize=14,
color=Color3.new(1,1,1),
x=Enum.TextXAlignment.Center,
y=Enum.TextYAlignment.Center,
})
t.Visible=p:Get()

s.MouseButton1Click:Connect(function()
if handle._locked then
return
end
local u=not p:Get()
p._silentSet(u,false)
end)
end

local t={
name=k.name or k.title or"Toggle",
type="Toggle",
value=p:Get(),
Instance=n.root,
Root=n.root,
TitleLabel=n.title,
DescLabel=n.desc,
ValueSource=p,
}
b.bind(t)

p:Changed(function(u,v)
t.value=u
if m=="switch"then
setKnob(u)
elseif s then
s:FindFirstChild"Check".Visible=u
if u then
e.tween(s,TweenInfo.new(0.1),{BackgroundColor3=theme().accent.color})
else
e.tween(s,TweenInfo.new(0.1),{BackgroundColor3=theme().window.carry2})
end
end
if k.callback then
pcall(k.callback,u,v)
end
if t._onChanged then
pcall(t._onChanged,u,v)
end
if j.onAny then
j.onAny(t,u)
end
end)

function t._setValue(u,v,w)
p:Set(v,w)
end


function t.Set(u,v,w)
p:Set(v,w)
return t
end


function t.Config(u)
if j.window and j.window.openConfigPopup then
j.window:openConfigPopup(t)
end
end

return t
end




function i.Slider(j)
local k=j.opts or{}
local l=j.parent

local m=b.row(l,k,k.height or 42)
local n=m.right

local o=k.min or 0
local p=k.max or 100
local q=k.suffix or""
local r=k.precise or k.showPercentage or false
local s=g.new(k.default or o)
local t=k.decimals or(r and 2 or 0)



local u=c.Label(n,{
name="Value",
size=UDim2.fromOffset(44,20),
anchor=Vector2.new(1,0.5),
text=tostring(math.floor(s:Get()*10)/10)..q,
textSize=12,
color=theme().text.slider,
zIndex=5,
x=Enum.TextXAlignment.Right,
})
u.Position=UDim2.new(1,0,0,0)


UDim2.new(0,0,0,0)
local v=c.Frame(n,{
name="Track",
size=UDim2.new(1,-52,0,4),
position=UDim2.new(0,0,0.5,-2),
anchor=Vector2.new(0,0),
transparency=0,
color=theme().slider.track,
block="slider",
key="track",
clips=false,
})
c.roundRect(v,2)

local w=0
local x=c.Frame(v,{
name="Fill",
size=UDim2.new(0,w,1,0),
transparency=0,
color=theme().slider.fill,
block="slider",
key="fill",
clips=false,
})
c.roundRect(x,2)

local y=c.Frame(v,{
name="Dot",
size=UDim2.fromOffset(14,14),
anchor=Vector2.new(0.5,0.5),
position=UDim2.new(0,0,0.5,0),
transparency=0,
color=theme().slider.handle,
block="slider",
key="handle",
clips=false,
zIndex=2,
})
c.roundRect(y,7)

local function valueText(z)
local A=("%."..t.."f"):format(z)
return A..q
end

local function setPos(z)
local A=v.AbsoluteSize.X
if A<=0 then
return
end
local B=math.clamp(z/A,0,1)
local C=o+(p-o)*B
if k.step then
C=math.round(C/k.step)*k.step
B=(C-o)/(p-o)
C=math.clamp(C,o,p)
end
y.Position=UDim2.fromScale(B,0.5)
C=math.clamp(C,o,p)

if w~=B then
w=B
x.Size=UDim2.new(0,math.max(0,B*v.AbsoluteSize.X),1,0)
end
envSplat(u,valueText(C),s:Get(),C)
end





local function updateFromValue(z)
local A=(z-o)/(p-o)
y.Position=UDim2.fromScale(math.clamp(A,0,1),0.5)
w=math.clamp(A,0,1)
x.Size=UDim2.new(0,math.max(0,w*v.AbsoluteSize.X),1,0)
u.Text=valueText(z)
end
updateFromValue(s:Get())

local function dragAt(z)
if not v.AbsoluteSize.X or v.AbsoluteSize.X<=0 then
return
end
local A=z-v.AbsolutePosition.X
setPos(A)
end

v.InputBegan:Connect(function(z)
if z.UserInputType==Enum.UserInputType.MouseButton1 or z.UserInputType==Enum.UserInputType.Touch then
dragAt(z.Position.X)
end
end)

v.InputChanged:Connect(function(z)

end)

local z=false
v.InputBegan:Connect(function(A)
if A.UserInputType==Enum.UserInputType.MouseButton1 or A.UserInputType==Enum.UserInputType.Touch then
z=true
end
end)
e.UserInputService.InputEnded:Connect(function(A)
if A.UserInputType==Enum.UserInputType.MouseButton1 or A.UserInputType==Enum.UserInputType.Touch then
z=false
end
end)
e.UserInputService.InputChanged:Connect(function(A)
if not z then
return
end
if A.UserInputType==Enum.UserInputType.MouseMovement or A.UserInputType==Enum.UserInputType.Touch then
dragAt(A.Position.X)
end
end)

local A={
name=k.name or k.title or"Slider",
type="Slider",
value=s:Get(),
Instance=m.root,
Root=m.root,
TitleLabel=m.title,
DescLabel=m.desc,
ValueSource=s,
Bar=v,
}
b.bind(A)

s:Changed(function(B,C)
A.value=B
updateFromValue(B)
if k.callback then
pcall(k.callback,B,C)
end
if A._onChanged then
pcall(A._onChanged,B,C)
end
end)

function A._setValue(B,C,D)
C=math.clamp(C,o,p)
s:Set(C,D)
end

function A.SetMin(B,C)
o=C
if s:Get()<o then
s:Set(o)
end
updateFromValue(s:Get())
end

function A.SetMax(B,C)
p=C
if s:Get()>p then
s:Set(p)
end
updateFromValue(s:Get())
end

function A.SetValue(B,C,D)
A:_setValue(C,D)
end

return A
end




function i.SliderGroup(j)
local k=j.opts or{}
local l=j.parent
local m=k.sliders or{}

local n=b.row(l,k,k.height or 40)
local o=n.inner

local p=c.Frame(o,{
name="Group",
size=UDim2.new(1,0,0,0),
transparency=1,
clips=false,
})
local q=Instance.new"UIListLayout"
q.SortOrder=Enum.SortOrder.LayoutOrder
q.Padding=UDim.new(0,6)
q.Parent=p

local r={}
for s,t in ipairs(m)do
r[s]=i.Slider{
parent=p,
opts={
name=t.title or("Slider "..s),
title=t.title or("Slider "..s),
min=t.min or 0,
max=t.max or 100,
step=t.step,
suffix=t.suffix or"",
default=t.default,
callback=t.callback,
},
}
r[s].Instance.Size=UDim2.new(1,0,0,42)
end

local function resize()
local s=0
for t,u in ipairs(p:GetChildren())do
if u:IsA"Frame"then
s=s+u.Size.Y.Offset+6
end
end
p.Size=UDim2.new(1,0,0,s)
n.root.Size=UDim2.new(1,0,0,k.height+s)
end
task.defer(resize)
p.ChildAdded:Connect(function()
task.defer(resize)
end)

return{
name=k.name or"SliderGroup",
type="SliderGroup",
Instance=n.root,
Root=n.root,
TitleLabel=n.title,
Sliders=r,
values=r,
}
end




function i.Dropdown(j)
local k=j.opts or{}
local l=j.parent
local m=k.multi or false local n=
k.search or false
local o=k.special
local p=k.values or{}

local q=b.row(l,k,k.height or 40)
local r=q.right


local s=c.Button(r,{
name="DropdownButton",
size=UDim2.new(1,0,0,28),
anchor=Vector2.new(1,0.5),
text=m and(k.placeholder or"Select...")or(k.placeholder or(type(p[1])=="string"and p[1])or"Select..."),
textSize=13,
transparency=0,
color=theme().window.carry2,
block="window",
key="carry2",
zIndex=3,
x=Enum.TextXAlignment.Left,
})
s.TextXAlignment=Enum.TextXAlignment.Center
c.roundRect(s,6)

local t=g.new(k.default or(m and{}or p[1]))

local u

s.MouseButton1Click:Connect(function()
if handle._locked then
return
end
if u and u.Visible then
u.Visible=false
return
end
if not u then
u=c.Frame(q.root,{
name="DropdownPopup",
size=UDim2.new(0,r.AbsoluteSize.X+16,0,8),
position=UDim2.new(1,-r.AbsoluteSize.X-8,0,q.root.AbsoluteSize.Y-4),
transparency=0,
color=theme().overlay.popup,
block="overlay",
key="popup",
clips=false,
zIndex=20,
})
c.roundRect(u,8)
local v=c.Frame(u,{
name="List",
size=UDim2.fromScale(1,1),
position=UDim2.fromOffset(0,0),
transparency=1,
})
local w=Instance.new"UIListLayout"
w.SortOrder=Enum.SortOrder.LayoutOrder
w.Padding=UDim.new(0,2)
w.Parent=v

local x=p
if o then
x=j.window and j.window:getSpecialItems(o)or p
end

local function rebuild()
for y,z in ipairs(v:GetChildren())do
if z:IsA"Frame"then
z:Destroy()
end
end
local y=0
for z,A in ipairs(x)do
local B=type(A)=="string"
local C=type(A)=="table"
if C and A.divider then
local D=c.Frame(v,{size=UDim2.new(1,-16,0,1),position=UDim2.fromOffset(8,0),transparency=1})
local E=Instance.new"UIStroke"
E.Color=theme().stroke.window
E.Transparency=0.85
E.Thickness=1
E.Parent=D
y=y+1
else
local D=B and A or A.title or tostring(A)local E=
C and A.desc or nil
local F=C and A.icon or nil
local G=c.Button(v,{
name="Item",
size=UDim2.new(1,0,0,30),
text=D,
textSize=13,
transparency=0,
color=theme().window.carry2,
hover=theme().accent.color,
block="window",
key="carry2",
x=Enum.TextXAlignment.Left,
})
c.roundRect(G,6)
if F and f.nameToGlyph(F)then
G.Text=f.nameToGlyph(F).."  "..D
end
y=y+32
G.MouseButton1Click:Connect(function()

if m then
local H=table.clone(t:Get())
local I
for J,K in ipairs(H)do
if K==A then
I=J
break
end
end
if I then
table.remove(H,I)
else
H[#H+1]=A
end
t:Set(H)
else
t:Set(A)
if u then
u.Visible=false
end
end
if C and A.callback then
pcall(A.callback,A)
end
end)
end
end
u.Size=UDim2.new(0,r.AbsoluteSize.X+16,0,y+4)
end
rebuild()
end
u.ZIndex=20
u.Visible=true
end)

local v={
name=k.name or k.title or"Dropdown",
type="Dropdown",
value=t:Get(),
Instance=q.root,
Root=q.root,
TitleLabel=q.title,
ValueSource=t,
}
b.bind(v)

t:Changed(function(w)
v.value=w
if m then
local x={}
for y,z in ipairs(w)do
x[#x+1]=type(z)=="string"and z or z.title or tostring(z)
end
s.Text=#x>0 and table.concat(x,", ")or(k.placeholder or"Select...")
else
s.Text=type(w)=="string"and w or(w and w.title)or tostring(w or"")
end
if k.callback then
pcall(k.callback,w)
end
if v._onChanged then
pcall(v._onChanged,w)
end
end)

function v._setValue(w,x,y)
t:Set(x,y)
end

function v.SetItems(w,x)
p=x
if u then
u.Visible=false
u:Destroy()
u=nil
end
end

function v.Config(w)
if j.window and j.window.openConfigPopup then
j.window:openConfigPopup(v)
end
end

return v
end




function i.Input(j)
local k=j.opts or{}
local l=j.parent
local m=b.row(l,k,k.height or 40)
local n=m.right

local o=c.Frame(n,{
name="InputBox",
size=UDim2.new(1,0,0,30),
anchor=Vector2.new(1,0.5),
transparency=0,
color=theme().window.carry2,
block="window",
key="carry2",
clips=true,
})
c.roundRect(o,6)

local p=Instance.new"TextBox"
p.Name="TextBox"
p.Size=UDim2.new(1,-12,1,0)
p.Position=UDim2.fromOffset(6,0)
p.BackgroundTransparency=1
p.BorderSizePixel=0
p.Text=k.default or k.value or""
p.PlaceholderText=k.placeholder or""
p.TextColor3=theme().text.input
p.TextTransparency=0
p.Font=Enum.Font.Code
p.TextSize=13
p.PlaceholderColor3=theme().text.desc
p.ClearTextOnFocus=k.clearOnFocus==true or k.clearTextOnFocus==true
p.TextXAlignment=Enum.TextXAlignment.Left
p.Parent=o

local q=g.new(k.default or"")
local r=k.finishedOnly or k.finished or false

local function publish(s)
if k.numeric and type(s)=="string"then
s=tonumber(s)or 0
end
q:Set(s,false)
end

p.FocusLost:Connect(function(s)
local t=p.Text
if k.numeric then
t=tonumber(t)
if t==nil then
t=q:Get()or 0
end
p.Text=tostring(t)
end
if r then
if s then
publish(t)
end
else
publish(t)
end
end)

p:GetPropertyChangedSignal"Text":Connect(function()
if not r then
publish(p.Text)
end
end)

local s={
name=k.name or k.title or"Input",
type="Input",
value=q:Get(),
Instance=m.root,
Root=m.root,
TitleLabel=m.title,
DescLabel=m.desc,
ValueSource=q,
TextBox=p,
}
b.bind(s)

q:Changed(function(t)
s.value=t
if k.callback then
pcall(k.callback,t)
end
if s._onChanged then
pcall(s._onChanged,t)
end
end)

function s._setValue(t,u,v)
q:Set(u,v)
p.Text=tostring(u)
end

function s.SetValue(t,u,v)
s:_setValue(u,v)
end

return s
end




function i.NumberInput(j)
local k=j.opts or{}
local l=j.parent
local m=b.row(l,k,k.height or 40)
local n=m.right

local o=k.default or 0
local p=k.step or 1
local q=k.min or-math.huge
local r=k.max or math.huge
local s=k.suffix or""
local t=g.new(o)

local u=c.Frame(n,{
size=UDim2.new(1,0,0,30),
anchor=Vector2.new(1,0.5),
transparency=1,
})

local v=c.Button(u,{
name="Minus",
size=UDim2.fromOffset(26,30),
text="−",
textSize=14,
transparency=0,
color=theme().window.carry2,
block="window",
key="carry2",
zIndex=3,
x=Enum.TextXAlignment.Center,
})
c.roundRect(v,6)
v.AnchorPoint=Vector2.new(0,0.5)
v.Position=UDim2.fromScale(0,0.5)

local w=Instance.new"TextBox"
w.Name="Display"
w.Size=UDim2.new(1,-64,1,0)
w.Position=UDim2.new(0,30,0,0)
w.BackgroundTransparency=1
w.BorderSizePixel=0
w.Text=tostring(o)..s
w.TextColor3=theme().text.input
w.Font=Enum.Font.Code
w.TextSize=13
w.TextXAlignment=Enum.TextXAlignment.Center
w.Parent=u

local x=c.Button(u,{
name="Plus",
size=UDim2.fromOffset(26,30),
text="+",
textSize=14,
transparency=0,
color=theme().window.carry2,
block="window",
key="carry2",
zIndex=3,
x=Enum.TextXAlignment.Center,
})
c.roundRect(x,6)
x.AnchorPoint=Vector2.new(1,0.5)
x.Position=UDim2.fromScale(1,0.5)

local function clampV(y)
return math.clamp(y,q,r)
end

local function update(y,z)
y=clampV(y)
w.Text=tostring(y)..s
t:Set(y,z)
end

v.MouseButton1Click:Connect(function()
update(t:Get()-p)
end)
x.MouseButton1Click:Connect(function()
update(t:Get()+p)
end)

w.FocusLost:Connect(function()
local y=tonumber(w.Text:gsub(s,""))
if y then
update(y)
else
w.Text=tostring(t:Get())..s
end
end)

local y={
name=k.name or k.title or"NumberInput",
type="NumberInput",
value=t:Get(),
Instance=m.root,
Root=m.root,
TitleLabel=m.title,
ValueSource=t,
}
b.bind(y)

t:Changed(function(z)
y.value=z
if k.callback then
pcall(k.callback,z)
end
if y._onChanged then
pcall(y._onChanged,z)
end
end)

function y._setValue(z,A,B)
update(A,B)
end

return y
end




function i.Textarea(j)
local k=j.opts or{}
local l=j.parent

local m=b.row(l,k,k.height or 100)
local n=m.inner

local o=c.Frame(n,{
size=UDim2.new(1,0,0,70),
position=UDim2.fromOffset(0,24),
transparency=0,
color=theme().window.carry2,
block="window",
key="carry2",
clips=true,
})
c.roundRect(o,6)

local p=Instance.new"TextBox"
p.Name="TextBox"
p.Size=UDim2.new(1,-12,1,-12)
p.Position=UDim2.fromOffset(6,6)
p.BackgroundTransparency=1
p.BorderSizePixel=0
p.MultiLine=true
p.TextWrapped=true
p.Text=k.default or k.value or""
p.PlaceholderText=k.placeholder or"Type here..."
p.TextColor3=theme().text.input
p.Font=Enum.Font.Code
p.TextSize=13
p.TextXAlignment=Enum.TextXAlignment.Left
p.TextYAlignment=Enum.TextYAlignment.Top
p.ClearTextOnFocus=false
p.Parent=o

local q=g.new(k.default or"")

p:GetPropertyChangedSignal"Text":Connect(function()
q:Set(p.Text)
end)

local r={
name=k.name or k.title or"Textarea",
type="Textarea",
value=q:Get(),
Instance=m.root,
Root=m.root,
TitleLabel=m.title,
ValueSource=q,
TextBox=p,
}
b.bind(r)

q:Changed(function(s)
r.value=s
if k.callback then
pcall(k.callback,s)
end
if r._onChanged then
pcall(r._onChanged,s)
end
end)

function r._setValue(s,t,u)
q:Set(t,u)
p.Text=tostring(t)
end

return r
end




function i.Keybind(j)
local k=j.opts or{}
local l=j.parent
local m=b.row(l,k,k.height or 40)
local n=m.right

local o=k.Button or k.Keybind or k.Value or k.value or k.key or k.default
local p=o
local q=h.parseUserInput(o)

local r=h.newKeybindState{
mode=k.mode or"always",
default=o,
callback=k.callback,
clickCallback=k.clickCallback,
}

local s=c.Button(n,{
name="Bind",
size=UDim2.fromOffset(120,28),
anchor=Vector2.new(1,0.5),
text=h.prettyName(p),
textSize=12,
transparency=0,
color=theme().window.carry2,
block="window",
key="carry2",
zIndex=3,
})
c.roundRect(s,6)

local t=false

s.MouseButton1Click:Connect(function()
if handle._locked then
return
end
t=not t
s.Text=t and"..."or h.prettyName(p)
end)

local u=e.UserInputService.InputBegan:Connect(function(u,v)
if not t then
return
end
if u.UserInputType==Enum.UserInputType.Keyboard then
local w,x=pcall(function()
if u.KeyCode==Enum.KeyCode.Escape then
return"esc"
end
return u.KeyCode
end)
if not w then
return
end
if x=="esc"then
t=false
s.Text=h.prettyName(p)
return
end
p=x
q={kind="key",keyCode=x,id=x.Name}
s.Text=h.prettyName(x)
r:SetKey(x)
t=false
if k.onKeyChanged then
pcall(k.onKeyChanged,p)
end
elseif u.UserInputType.Name:match"MouseButton"then
p=u.UserInputType
q={kind="mouse",inputType=u.UserInputType,id=u.UserInputType.Name}
s.Text=h.prettyName(u.UserInputType)
r:SetKey(u.UserInputType)
t=false
if k.onKeyChanged then
pcall(k.onKeyChanged,p)
end
end
end)

local v={
name=k.name or k.title or"Keybind",
type="Keybind",
value=p,
Instance=m.root,
Root=m.root,
TitleLabel=m.title,
ValueSource=valueSourceFrom2(p),
}
b.bind(v)

function v._setValue(w,x,y)
local z=h.parseUserInput(x)
if z then
q=z
p=z.kind=="mouse"and z.inputType or z.keyCode
s.Text=h.prettyName(p)
r:SetKey(p)
else
p=nil
q=nil
s.Text="None"
r:SetKey(nil)
end
v.value=p
end

function v.SetKey(w,x)
v:_setValue(x)
end

function v.GetState(w)
return r:GetState()
end

function v.SetMode(w,x)
r.mode=x
end

function v.ToMode(w,x)
r.mode=x
end

function v.Destroy(w)
if u then
u:Disconnect()
end
r:Destroy()
end

return v
end









function i.Colorpicker(j)
local k=j.opts or{}
local l=j.parent
local m=b.row(l,k,k.height or 40)
local n=m.right

local o=k.default or Color3.new(1,0,0)
local p=g.new(o)
local q=k.alpha and 1 or 0

local r=c.Button(n,{
name="Swatch",
size=UDim2.fromOffset(38,28),
anchor=Vector2.new(1,0.5),
text="",
transparency=0,
color=p:Get(),
block="colorpicker",
key="swatch",
zIndex=3,
})
c.roundRect(r,6)

local s

r.MouseButton1Click:Connect(function()
if handle._locked then
return
end
if s and s.Visible then
s.Visible=false
return
end
if not s then
s=c.Frame(m.root,{
name="ColorPopup",
size=UDim2.fromOffset(180,180),
position=UDim2.new(1,-n.AbsoluteSize.X-8,0,m.root.AbsoluteSize.Y-4),
transparency=0,
color=theme().overlay.popup,
block="overlay",
key="popup",
clips=true,
zIndex=20,
})
c.roundRect(s,8)


local t=c.Frame(s,{
name="Hue",
size=UDim2.fromOffset(160,10),
position=UDim2.fromOffset(10,150),
transparency=1,
clips=false,
})
local u=Instance.new"UIGradient"
u.Rotation=90
local v={}
for w=0,10 do
v[#v+1]=ColorSequenceKeypoint.new(w/10,Color3.fromHSV(w/10,1,1))
end
u.Color=ColorSequence.new(v)
u.Parent=t
c.roundRect(t,5)


local w=c.Frame(s,{
name="Grid",
size=UDim2.fromOffset(160,130),
position=UDim2.fromOffset(10,10),
transparency=1,
clips=false,
})
c.roundRect(w,5)
local x,y,z=Color3.toHSV(p:Get())
local A=Instance.new"UIGradient"
A.Rotation=90
A.Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromHSV(x,1,1))
A.Parent=w
local B=Instance.new"UIGradient"
B.Rotation=0
B.Color=ColorSequence.new(Color3.new(0,0,0),Color3.new(1,1,1))
B.Transparency=NumberSequence.new(0,1)
B.Parent=w

local C=c.Frame(w,{
name="Dot",
size=UDim2.fromOffset(8,8),
position=UDim2.fromScale(y,1-z),
anchor=Vector2.new(0.5,0.5),
transparency=0,
color=p:Get(),
clips=false,
zIndex=2,
})
c.roundRect(C,4)





local function pick()
local D=C.Position
local E,F=D.X,1-D.Y
local G=currentHue or x
local H=Color3.fromHSV(G,math.clamp(E,0,1),math.clamp(F,0,1))
p:Set(H)
C.Position=UDim2.fromScale(math.clamp(E,0,1),math.clamp(1-F,0,1))
C.BackgroundColor3=H
r.BackgroundColor3=H
end

local D=x
w.InputBegan:Connect(function(E)
if E.UserInputType==Enum.UserInputType.MouseButton1 or E.UserInputType==Enum.UserInputType.Touch then
local F=math.clamp((E.Position.X-w.AbsolutePosition.X)/w.AbsoluteSize.X,0,1)
local G=math.clamp((E.Position.Y-w.AbsolutePosition.Y)/w.AbsoluteSize.Y,0,1)
C.Position=UDim2.fromScale(F,G)
local H=Color3.fromHSV(D,F,1-G)
p:Set(H)
r.BackgroundColor3=H
C.BackgroundColor3=H
end
end)

t.InputBegan:Connect(function(E)
if E.UserInputType==Enum.UserInputType.MouseButton1 or E.UserInputType==Enum.UserInputType.Touch then
local F=math.clamp((E.Position.X-t.AbsolutePosition.X)/t.AbsoluteSize.X,0,1)
D=F
A.Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromHSV(F,1,1))
pick()
end
end)
end
s.Visible=true
end)

local t={
name=k.name or k.title or"Colorpicker",
type="Colorpicker",
value=p:Get(),
Instance=m.root,
Root=m.root,
TitleLabel=m.title,
ValueSource=p,
}
b.bind(t)

p:Changed(function(u)
t.value=u
r.BackgroundColor3=u
if k.callback then
pcall(k.callback,u,q)
end
if t._onChanged then
pcall(t._onChanged,u)
end
end)

function t._setValue(u,v,w)
p:Set(v,w)
r.BackgroundColor3=v
end

function t.SetValue(u,v,w,x)
p:Set(v,x)
r.BackgroundColor3=v
end

return t
end




function i.Label(j)
local k=j.opts or{}
local l=j.parent

local m=c.Label(l,{
name=k.name or"Label",
size=k.size or UDim2.new(1,0,0,k.height or 20),
text=k.title or k.text or"",
textSize=k.textSize or 14,
color=k.color or theme().text.label,
x=k.x or Enum.TextXAlignment.Left,
font=k.font or Enum.Font.Code,
wrap=k.wrap,
})

local n={
name=k.name or k.title or"Label",
type="Label",
value=m.Text,
Instance=m,
Root=m,
TitleLabel=m,
}
b.bind(n)

function n.SetText(o,p)
m.Text=p
n.value=p
end

function n._setValue(o,p)
m.Text=tostring(p or"")
n.value=m.Text
end

return n
end

i.Paragraph=function(j)
local k=j.opts or{}
k.height=k.height or 40
k.wrap=true
return i.Label(j)
end

function i.Divider(j)
local k=j.opts or{}
local l=j.parent
local m=c.Frame(l,{
name=k.name or"Divider",
size=UDim2.new(1,-24,0,1),
position=k.direction=="vertical"and UDim2.new(0.5,0,0.5,0)or nil,
transparency=1,
})
local n=Instance.new"UIStroke"
n.Color=theme().stroke.window
n.Transparency=0.9
n.Thickness=2
n.Parent=m

local o={
name=k.name or"Divider",
type="Divider",
Instance=m,
Root=m,
}
b.bind(o)
return o
end

function i.Space(j)
local k=j.opts or{}
local l=j.parent
local m=c.Frame(l,{
name=k.name or"Space",
size=UDim2.new(1,0,0,k.height or 8),
transparency=1,
})
local n={
name=k.name or"Space",
type="Space",
Instance=m,
Root=m,
}
b.bind(n)
return n
end




function i.Stat(j)
local k=j.opts or{}
local l=j.parent
local m=b.row(l,k,k.height or 40)
local n=m.right

local o=g.new(k.value or 0)
local p=k.decimals or(k.suffix and 0 or 2)

local q=c.Label(n,{
name="Value",
size=UDim2.fromScale(1,1),
anchor=Vector2.new(1,0.5),
position=UDim2.new(1,0,0,0),
text=tostring(o:Get()),
textSize=14,
color=theme().accent.color,
x=Enum.TextXAlignment.Right,
})

local r={
name=k.name or k.title or"Stat",
type="Stat",
value=o:Get(),
Instance=m.root,
Root=m.root,
TitleLabel=m.title,
ValueSource=o,
}
b.bind(r)

o:Changed(function(s,t)
r.value=s

local u=t or s
local v=os.clock()
local w=0.3
local x
x=e.UserInputService:GetPropertyChangedSignal"WindowFocused":Connect(function()end)
x:Disconnect()

local y=game:GetService"RunService".RenderStepped
local z
z=y:Connect(function()
local A=math.min((os.clock()-v)/w,1)
local B=A*A*(3-2*A)
local C=u+(s-u)*B
q.Text=string.format("%."..p.."f",C)..(k.suffix or"")
if A>=1 then
q.Text=string.format("%."..p.."f",s)..(k.suffix or"")
z:Disconnect()
end
end)
if k.callback then
pcall(k.callback,s)
end
if r._onChanged then
pcall(r._onChanged,s)
end
end)

function r._setValue(s,t,u)
o:Set(t,u)
end

function r.Set(s,t,u)
o:Set(t,u)
return r
end

return r
end




function i.Code(j)
local k=j.opts or{}
local l=j.parent
local m=b.row(l,k,k.height or 120)
local n=m.inner

local o=Instance.new"TextBox"
o.Name="Code"
o.Size=UDim2.new(1,0,0,k.height-50)
o.Position=UDim2.fromOffset(0,26)
o.BackgroundTransparency=0
o.BackgroundColor3=theme().window.carry
o.BorderSizePixel=0
o.Text=k.code or""
o.TextColor3=theme().text.input
o.Font=Enum.Font.Code
o.TextSize=12
o.TextXAlignment=Enum.TextXAlignment.Left
o.TextYAlignment=Enum.TextYAlignment.Top
o.MultiLine=true
o.TextWrapped=true
o.ClearTextOnFocus=false
o.Parent=n

local p=c.Button(n,{
name="Copy",
size=UDim2.fromOffset(40,20),
position=UDim2.new(1,0,0,0),
anchor=Vector2.new(1,0),
text="Copy",
textSize=11,
transparency=0,
color=theme().window.carry2,
block="window",
key="carry2",
zIndex=3,
})
c.roundRect(p,4)
p.MouseButton1Click:Connect(function()
local q=getgenv and getgenv().setclipboard
if q then
pcall(q,o.Text)
p.Text="✓"
task.defer(function()
task.wait(0.8)
p.Text="Copy"
end)
end
end)

local q={
name=k.name or k.title or"Code",
type="Code",
value=o.Text,
Instance=m.root,
Root=m.root,
TitleLabel=m.title,
TextBox=o,
}
b.bind(q)
return q
end




function i.Image(j)
local k=j.opts or{}
local l=j.parent
local m=b.row(l,k,k.height or(k.size and nil)or 120)

local n=k.size or UDim2.new(1,-16,0,k.height-8 or 110)
local o
if k.asset then
o=Instance.new"ImageLabel"
o.Image=k.asset
o.BackgroundTransparency=1
o.BorderSizePixel=0
else

o=c.Label(m.inner or l,{
name="Image",
size=n,
text=k.glyph or"▧",
textSize=k.glyph and 40 or 24,
color=theme().accent.color,
x=Enum.TextXAlignment.Center,
y=Enum.TextYAlignment.Center,
})
end
o.Parent=m.inner or l
c.roundRect(o,8)

m.root.Size=UDim2.new(1,0,0,(k.height or 120))

local p={
name=k.name or k.title or"Image",
type="Image",
value=nil,
Instance=m.root,
Root=m.root,
}
b.bind(p)
return p
end




function i.Tag(j)
local k=j.opts or{}
local l=j.parent
local m=b.row(l,k,k.height or 28)local n=
m.right

local o=k.tone or"default"
local p=k.color
or(o=="success"and theme().status.success)
or(o=="warning"and theme().status.warning)
or(o=="error"and theme().status.error)
or(o=="info"and theme().status.info)
or(o=="risky"and theme().status.risky)
or theme().accent.color

local q=c.Frame(m.inner,{
name="Chip",
size=UDim2.new(0,0,0,22),
anchor=Vector2.new(1,0.5),
position=UDim2.new(1,-4,0.5,0),
transparency=0,
color=p,
clips=false,
})
c.roundRect(q,11)
local r=c.Label(q,{
name="Text",
size=UDim2.fromScale(1,1),
text=(k.icon and(f.nameToGlyph(k.icon).." ")or"")..(k.label or k.title or""),
textSize=11,
color=Color3.new(1,1,1),
x=Enum.TextXAlignment.Center,
})
q.Size=UDim2.fromOffset(r.TextBounds.X+16,22)

local s={
name=k.name or"Tag",
type="Tag",
value=k.label,
Instance=m.root,
Root=m.root,
TitleLabel=m.title,
}
b.bind(s)

function s.Set(t,u)
r.Text=u
q.Size=UDim2.fromOffset(r.TextBounds.X+16,22)
s.value=u
end

return s
end




function i.Watermark(j)
local k=j.opts or{}
local l=j.parent

local m=c.Frame(l,{
name=k.name or"Watermark",
size=k.size or UDim2.fromOffset(280,34),
position=k.position or UDim2.new(0,8,1,-40),
anchor=k.anchor or Vector2.new(0,1),
transparency=0,
color=theme().window.carry,
block="window",
key="carry",
clips=false,
zIndex=10,
})
c.roundRect(m,8)

local n=c.Label(m,{
name="Text",
size=UDim2.fromScale(1,1),
text=k.text or"Kronos v1.0",
textSize=12,
color=theme().text.label,
x=Enum.TextXAlignment.Center,
})
n.Position=UDim2.fromOffset(8,0)

m.InputBegan:Connect(function(o)
if o.UserInputType==Enum.UserInputType.MouseButton1 then

local p={start=o.Position,pos=m.Position}
local q
q=e.UserInputService.InputChanged:Connect(function(r)
if r.UserInputType==Enum.UserInputType.MouseMovement then
m.Position=p.pos+UDim2.fromOffset(r.Position.X-p.start.X,r.Position.Y-p.start.Y)
end
end)
e.UserInputService.InputEnded:Wait()
q:Disconnect()
end
end)

local o={
name=k.name or"Watermark",
type="Watermark",
Instance=m,
Root=m,
Label=n,
}
b.bind(o)

function o.SetText(p,q)
n.Text=q
end

return o
end

i.add=function(j,k)
i[j]=k
end

return i end function a.l():typeof(__modImpl())local b=a.cache.l if not b then b={c=__modImpl()}a.cache.l=b end return b.c end end do local function __modImpl()





local b=a.a()

local c={}
c.__index=c

local d=1


local function serialize(e)
if typeof(e)=="Color3"then
return{__t="Color3",r=e.R,g=e.G,b=e.B}
end
if typeof(e)=="EnumItem"then
return{__t="EnumItem",e=tostring(e.EnumType.Name),v=e.Value}
end
if typeof(e)=="table"then
local f={}
for g,h in pairs(e)do
f[g]=serialize(h)
end
return f
end
return e
end

local function deserialize(e)
if type(e)=="table"and e.__t=="Color3"then
return Color3.new(e.r,e.g,e.b)
end
if type(e)=="table"and e.__t=="EnumItem"then
if e.e=="KeyCode"and type(e.v)=="number"then
local f,g=pcall(function()
return Enum.KeyCode[e.v]
end)
if f and g then
return g
end
end
return nil
end
if type(e)=="table"then
local f={}
for g,h in pairs(e)do
f[g]=deserialize(h)
end
return f
end
return e
end

local function baseDir()
return"workspace"
end

function c.toKronosDir(e)
return baseDir().."/Kronos/"..tostring(e or"Hub")
end

local function escapePath(e)
return tostring(e):gsub("[^%w_%-. ]","_")
end

function c.loadFileData(e)
if not b.fs.readFile then
return nil
end
local f,g=b.fs.readFile(e)
if not f or not g then
return nil
end
return b.decode(g)
end

function c.encodeConfig(e,f,g)
return b.encode{
schemaVersion=g or d,
name=e,
values=f,
}
end




local e={}
e.__index=e

function e.new(f,g)
return setmetatable({
manager=f,
name=g or"Main",
registrations={},
},e)
end

function e.Register(f,g,h)
if type(g)=="string"then
f.registrations[g]=h
else
local i=g
f.registrations[i.name or i.flag or"el"]=i
end
end

function e.collectValues(f)
local g={}
for h,i in pairs(f.registrations)do
if type(i)=="table"and i.value~=nil then
g[h]=serialize(i.value)
end
end
return g
end

function e.path(f,g)
local h=f.manager
local i=c.toKronosDir(h.hubName)
local j=g or(h.gameId and tostring(h.gameId)or"global")
return i.."/"..escapePath(j).."/"..escapePath(f.name)..".json"
end

function e.Save(f,g)
if not b.fs.supported then
return false
end
local h=c.toKronosDir(f.manager.hubName)
local i=g or(f.manager.gameId and tostring(f.manager.gameId)or"global")
b.fs.ensureFolder(h)
b.fs.ensureFolder(h.."/"..escapePath(i))
local j=c.encodeConfig(f.name,f:collectValues())
local k=pcall(b.fs.writeFile,f:path(g),j)
return k
end

function e.applyValues(f,g)
local h=0
for i,j in pairs(f.registrations)do
local k=g[i]
if k~=nil then
local l=deserialize(k)
if type(j)=="table"and j._setValue then
j:_setValue(l,true)
h=h+1
elseif type(j)=="table"and j.Set then
pcall(j.Set,j,l,true)
h=h+1
end
end
end
return h>0
end

function e.Load(f,g)
if not b.fs.readFile then
return false
end
local h=c.loadFileData(f:path(g))
if not h or type(h.values)~="table"then
return false
end
return f:applyValues(h.values)
end

function e.Delete(f,g)
if not b.fs.deleteFile then
return false
end
local h=pcall(b.fs.deleteFile,f:path(g))
return h,nil
end


function e.Export(f)
local g={
v=d,
n=f.name,
x=f:collectValues(),
}
return b.encode(b.encode(g))
end

function e.Import(f,g)
local h=b.decode(g)
if not h then
return false
end
local i=b.decode(h)
if not i or type(i.x)~="table"then
return false
end
local j=i.x
if i.m and type(i.m)=="table"then
for k,l in pairs(i.m)do
if j[k]and not j[l]then
j[l]=j[k]
end
end
end
return f:applyValues(j)
end




local f={}
f.__index=f

function f.new(g)
g=g or{}
local h=setmetatable({
hubName=g.folder or g.folderName or g.hubName or"Hub",
gameId=g.gameId or game.PlaceId,
autoSave=g.autoSave==nil and true or g.autoSave,
autoLoad=g.autoLoad==nil and true or g.autoLoad,
configs={},
migration=g.migration or{},
},f)


local i=e.new(h,"Main")
h.configs.Main=i


local j=i.applyValues
function i.applyValues(k,l)
local m={}
for n,o in pairs(l)do
m[n]=o
end
for n,o in pairs(k.manager.migration)do
if m[n]and not m[o]then
m[o]=m[n]
end
end
return j(k,m)
end

if h.autoLoad then
h:loadAutoload()
end
if h.autoSave then
h:startAutosave(g.saveDelay or 30)
end
return h
end

function f.setGameId(g,h)
g.gameId=h
end

function f.CreateConfig(g,h)
local i=e.new(g,h)
g.configs[h or"Main"]=i
return i
end

function f.GetConfig(g,h)
return g.configs[h]or g:CreateConfig(h)
end

function f.AllConfigs(g)
local h={}
for i in pairs(g.configs)do
h[#h+1]=i
end
return h
end

function f.autoRegister(g,h)
if not h or not h.name then
return
end
local i=g:GetConfig"Main"
if h._setValue and h.value~=nil then
i:Register(h.name,h)
end
end

function f.saveAll(g)
for h,i in pairs(g.configs)do
i:Save()
end
end

function f.loadAutoload(g)
if not b.fs.supported then
return
end
local h=c.toKronosDir(g.hubName)
local i={"global"}
if g.gameId then
table.insert(i,tostring(g.gameId))
end
local j=g:GetConfig"Main"
for k,l in ipairs(i)do
local m=c.loadFileData(h.."/"..escapePath(l).."/Main.json")
if m and type(m.values)=="table"then
j:applyValues(m.values)
return
end
end
end

function f.startAutosave(g,h)
g._autoTick=task.spawn(function()
repeat
task.wait(h or 30)
if b.fs.supported then
pcall(function()
g:saveAll()
end)
end
until false
end)
end

function f.stopAutosave(g)
if g._autoTick then
task.cancel(g._autoTick)
end
end

function f.Destroy(g)
g:stopAutosave()
g:saveAll()
end


c.buildMigrationMap=function(g)
return g
end
c.NamedConfig=e
c.ConfigManager=f
c.SCHEMA_VERSION=d
c.serialize=serialize
c.deserialize=deserialize

return c end function a.m():typeof(__modImpl())local b=a.cache.m if not b then b={c=__modImpl()}a.cache.m=b end return b.c end end do local function __modImpl()




local b=a.a()
local c=a.e()
local d=a.c()
local e=a.f()
local f=a.g()
local g=a.l()
local h=a.d()a.k()

local i=a.i()
local j=a.m()

local k=game:GetService"Players"
game:GetService"TweenService"
game:GetService"RunService"

local function theme()
return d.Get(d.currentName or"Dark")
end


local function asContainer(l)
if l and l.Holder then
return l
end
if l and l.Stack then
return l
end
return nil
end


local function containerInstance(l)
if not l then
return nil
end
if l.Holder then
return l.Holder
end
if l.Stack then
return l.Stack
end
if l.Root then
return l.Root
end
if l.Instance then
return l.Instance
end
return l
end


local function normalizeOpts(l)
if type(l)=="string"then
return{title=l,name=l}
end
return l or{}
end

local l={}
l.__index=l

function l.new(m,n)
n=n or{}

local o=setmetatable({},l)
o.screen=m
o.opts=n
o.tabs={}
o.containers={}
o.globalSettings={}
o.hasOpenButton=false


o.chrome=n.chrome or"default"
o.dragStyle=n.dragStyle or 1
o.resizable=n.resizable==nil and true or n.resizable
o.acrylic=n.acrylic or false


o.size=n.size or UDim2.fromOffset(640,480)
o.minSize=n.minSize or Vector2.new(520,360)
o.maxSize=n.maxSize or Vector2.new(900,620)


o.zeroAsset=n.zeroAsset==nil and true or n.zeroAsset


if n.configuration then
o.config=j.ConfigManager.new(n.configuration)
end

o:build()


o.drag=f.attach{
handle=o.HeaderBar,
root=o.Root,
minSize=o.minSize,
maxSize=o.maxSize,
resizable=o.resizable,
dragStyle=o.dragStyle,
sizeCallback=function(p,q)
o:onResize()
end,
}

return o
end




function l.build(m)
local n=m.opts
local o=theme()


local q=c.Frame(m.screen,{
name="KronosWindow",
size=m.size,
position=UDim2.fromScale(0.5,0.5),
anchor=Vector2.new(0.5,0.5),
transparency=0,
color=o.window.background,
block="window",
key="background",
clips=true,
zIndex=1,
})
c.roundRect(q,o.rounded.window)
local r=Instance.new"UIStroke"
r.Color=Color3.fromRGB(255,255,255)
r.Transparency=0.85
r.Thickness=1
r.Parent=q

m.Root=q


local s=c.Frame(q,{
name="HeaderBar",
size=UDim2.new(1,0,0,44),
transparency=0,
color=o.window.topbar,
block="window",
key="topbar",
clips=false,
})
m.HeaderBar=s

local t=c.Label(s,{
name="Title",
size=UDim2.new(1,-90,1,0),
position=UDim2.fromOffset(12,0),
text=n.title or"Kronos",
textSize=o.font.sizes.window_title,
color=o.text.window,
x=Enum.TextXAlignment.Left,
font=Enum.Font.Code,
})
m.TitleLabel=t
if n.subtitle then

local u=c.Label(s,{
name="Subtitle",
size=UDim2.new(1,-90,0,12),
position=UDim2.fromOffset(12,24),
text=n.subtitle,
textSize=11,
color=o.text.subtile,
x=Enum.TextXAlignment.Left,
font=Enum.Font.Code,
})
m.SubtitleLabel=u
end


if m.chrome=="mac"then
m:buildMacButtons(s)
else
m:buildDefaultButtons(s)
end


local u=c.Frame(q,{
name="Sidebar",
size=UDim2.fromOffset(176,1),
position=UDim2.new(0,0,0,44),
transparency=0,
color=o.window.sidebar,
block="window",
key="sidebar",
clips=true,
})
u.Size=UDim2.new(0,176,1,-44)
m.Sidebar=u


local v=c.Frame(u,{
name="Logo",
size=UDim2.new(1,0,0,56),
transparency=1,
})
c.IconLabel(v,{
icon=n.icon or"settings",
size=UDim2.fromOffset(26,26),
position=UDim2.fromOffset(12,15),
color=o.accent.color,
textSize=20,
})
c.Label(v,{
name="Text",
size=UDim2.new(0,120,0,30),
position=UDim2.fromOffset(44,13),
text=n.title or"Kronos",
textSize=15,
color=o.text.window,
x=Enum.TextXAlignment.Left,
font=Enum.Font.Code,
})
if n.version then
local w=c.Label(v,{
name="Version",
size=UDim2.fromOffset(50,14),
position=UDim2.new(1,-54,0,8),
text=n.version,
textSize=9,
color=o.text.subtile,
x=Enum.TextXAlignment.Right,
})
m.VersionLabel=w
end


if n.searchbar~=false then
local w=Instance.new"TextBox"
w.Name="Search"
w.Size=UDim2.new(1,-20,0,26)
w.Position=UDim2.fromOffset(10,62)
w.BackgroundTransparency=0
w.BackgroundColor3=o.window.sidebarItem
w.BorderSizePixel=0
w.PlaceholderText="Search..."
w.PlaceholderColor3=o.text.subtile
w.TextColor3=o.text.window
w.Font=Enum.Font.Code
w.TextSize=13
w.TextXAlignment=Enum.TextXAlignment.Left
w.Text=""
w.Parent=u
c.roundRect(w,8)
m.searchBox=w
end


local w=c.Scroll(u,{
name="Tabs",
size=UDim2.new(1,0,1,-100),
position=UDim2.new(0,0,0,94),
thickness=2,
})
m.SidebarScroll=w
local x=c.Frame(w,{
name="Holder",
size=UDim2.new(1,0,0,0),
transparency=1,
clips=false,
})
local y=Instance.new"UIListLayout"
y.Name="KronosList"
y.SortOrder=Enum.SortOrder.LayoutOrder
y.Padding=UDim.new(0,4)
y.Parent=x
m.SidebarHolder=x
m.SidebarList=y


local z=c.Frame(q,{
name="Rail",
size=UDim2.fromOffset(40,44),
position=UDim2.new(1,-40,0,0),
transparency=0,
color=o.window.rail,
block="window",
key="rail",
})
m.Rail=z

z.Visible=false


local A=c.Frame(q,{
name="Content",
size=UDim2.new(1,-176,1,-44),
position=UDim2.new(0,176,0,44),
transparency=0,
color=o.window.foreground,
block="window",
key="foreground",
clips=true,
zIndex=2,
})
m.Content=A


if n.homeTab~=false then
local B=m:buildHomeTab()
m.homeTab=B
m:selectTab(B)
else
A.Visible=false
end

m.XPContent=nil
end

function l.buildDefaultButtons(m,n)
local o=theme()
local q=m
local r=0
local function makeBtn(s,t,u)
local v=c.IconLabel(n,{
icon=s,
size=UDim2.fromOffset(22,22),
position=UDim2.new(1,-(18+r),0.5,-11),
color=o.chromium.topbarIcon,
textSize=13,
})
r=r+28
v.InputBegan:Connect(function(w)
if w.UserInputType==Enum.UserInputType.MouseButton1 and u then
u()
end
end)
return v
end
local s=makeBtn("minimize",nil,function()
q:minimize()
end)
local t=makeBtn("pin",nil,function()
q:setAlwaysOnTop(not q.alwaysOnTop)
end)
local u=makeBtn("close",o.status.error,function()
q:destroy()
end)
m.MinBtn=s
m.PinBtn=t
m.CloseBtn=u
end

function l.buildMacButtons(m,n)
local o=theme()
local q={"close","minimize","maximize"}
for r,s in ipairs(q)do
local t=o.chromium.mac
local u=s=="close"and t.close or(s=="minimize"and t.min or t.max)
local v=c.Frame(n,{
name="Mac_"..s,
size=UDim2.fromOffset(14,14),
position=UDim2.new(1,-(16+(r-1)*24),0.5,-7),
transparency=0,
color=u,
})
c.roundRect(v,7)
if s=="close"then
v.InputBegan:Connect(function(w)
if w.UserInputType==Enum.UserInputType.MouseButton1 then
m:destroy()
end
end)
end
end

m.HeaderBar:FindFirstChild"Title".Size=UDim2.new(1,-110,1,0)
end




function l.buildHomeTab(m)
local n=theme()
local o=m.Content

local q=c.Frame(o,{
name="Home",
size=UDim2.fromScale(1,1),
transparency=0,
color=n.window.foreground,
block="window",
key="foreground",
clips=true,
})

c.IconLabel(q,{
icon=m.opts.icon or"settings",
size=UDim2.fromOffset(64,64),
position=UDim2.new(0.5,-32,0,28),
color=n.accent.color,
textSize=52,
})
c.Label(q,{
name="Title",
size=UDim2.new(1,-40,0,40),
position=UDim2.new(0,20,0,100),
text=m.opts.title or"Kronos",
textSize=24,
color=n.text.window,
x=Enum.TextXAlignment.Center,
font=Enum.Font.Code,
})
c.Label(q,{
name="Subtitle",
size=UDim2.new(1,-40,0,20),
position=UDim2.new(0,20,0,140),
text=m.opts.subtitle or"UI Library",
textSize=13,
color=n.text.subtile,
x=Enum.TextXAlignment.Center,
})


if m.opts.supportedExecutors then
c.Label(q,{
name="Supported",
size=UDim2.new(1,-40,0,20),
position=UDim2.new(0,20,0,180),
text="Supported executors: "..table.concat(m.opts.supportedExecutors," · "),
textSize=12,
color=n.text.desc,
x=Enum.TextXAlignment.Center,
})
end
if m.opts.discordInvite then
local r=c.Button(q,{
name="Discord",
size=UDim2.fromOffset(160,34),
position=UDim2.new(0.5,-80,0,240),
text="Discord",
textSize=13,
transparency=0,
color=n.accent.color,
hover=n.accent.hover,
block="accent",
key="color",
})
c.roundRect(r,8)
r.MouseButton1Click:Connect(function()
if m.opts.discordInvite then local s=
getgenv and getgenv().clippy
pcall(function()
if getgenv().setclipboard then
getgenv().setclipboard("discord.gg/"..m.opts.discordInvite)
end
end)
r.Text="Copied!"
task.defer(function()
task.wait(1)
r.Text="Discord"
end)
end
end)
end


if m.opts.changelog and#m.opts.changelog>0 then
c.Label(q,{
size=UDim2.new(1,-40,0,20),
position=UDim2.new(0,20,0,300),
text="CHANGELOG",
textSize=12,
color=n.text.subtile,
x=Enum.TextXAlignment.Center,
})
local r={}
for s,t in ipairs(m.opts.changelog)do
r[#r+1]=t.version.." — "..table.concat(t.changes or{},", ")
end
c.Label(q,{
size=UDim2.new(1,-40,0,30*#r),
position=UDim2.new(0,20,0,322),
text=table.concat(r,"\n"),
textSize=12,
color=n.text.desc,
x=Enum.TextXAlignment.Center,
wrap=true,
})
end

local r={
name="Home",
icon="home",
Root=q,
window=m,
}
m:addTab(r)
return r
end




function l.addTab(m,n)
m.tabs[#m.tabs+1]=n

local o=theme()
local q=c.Button(m.SidebarHolder,{
name="Tab_"..n.name,
size=UDim2.new(1,-16,0,34),
text=(n.icon and(h.nameToGlyph(n.icon).." ")or"")..n.name,
textSize=13,
transparency=0,
color=o.window.sidebarItem,
block="window",
key="sidebarItem",
x=Enum.TextXAlignment.Left,
})
q.Position=UDim2.fromOffset(8,0)
c.roundRect(q,7)
n.Button=q
q.MouseButton1Click:Connect(function()
m:selectTab(n)
end)

task.defer(function()
m.SidebarScroll.CanvasSize=UDim2.fromOffset(0,(m.SidebarHolder.AbsoluteSize.Y+8))
end)
end

function l.selectTab(m,n)
for o,q in ipairs(m.tabs)do
q.Root.Visible=q==n
if q.Button then
local r=theme()
q.Button.BackgroundColor3=q==n and r.window.sidebarItem or r.window.sidebar
q.Button.TextColor3=q==n and r.text.window or r.text.subtile
end
end
m.currentTab=n
m.pendingTab=n
end







local m={
"CreateColumn","CreateSection","CreateGroupbox","CreateTabGroup",
"CreateButton","CreateToggle","CreateSlider","CreateSliderGroup",
"CreateDropdown","CreateInput","CreateNumberInput","CreateTextarea",
"CreateKeybind","CreateColorpicker","CreateLabel","CreateParagraph",
"CreateDivider","CreateSpace","CreateStat","CreateCode","CreateImage",
"CreateTag","CreateWatermark","CreateCodeblock",
}

local function attachBuilders(n,o)
o.window=n
for q,r in ipairs(m)do
o[r]=function(s,t)
local u
if t~=nil or type(s)~="table"then
u=o
t=s
else
u=s
end
return n[r](n,u,normalizeOpts(t))
end
end
return o
end
l.attachBuilders=attachBuilders

function l.CreateTab(n,o)
o=o or{}
local q=theme()
local r=c.Frame(n.Content,{
name="Tab_"..tostring(o.name or"Tab"),
size=UDim2.fromScale(1,1),
transparency=0,
color=q.window.foreground,
block="window",
key="foreground",
clips=true,
zIndex=2,
})
local s=c.Frame(r,{
name="Stack",
size=UDim2.new(1,0,1,0),
position=UDim2.fromOffset(12,10),
transparency=1,
clips=false,
})
local t=Instance.new"UIListLayout"
t.Name="KronosStack"
t.SortOrder=Enum.SortOrder.LayoutOrder
t.Padding=UDim.new(0,8)
t.Parent=s

local u={
name=o.name or"Tab",
icon=o.icon,
Root=r,
Stack=s,
window=n,
}

n:addTab(u)
if o.onSelect then
u.onSelect=o.onSelect
end
return attachBuilders(n,u)
end


function l.CreateColumn(n,o,q)
return n:MakeColumn(o,q)
end



function l.CreateTabGroup(n,o,q)
q=q or{}
local r=theme()
local s=asContainer(o,n)

local t
if s then
t=s.Holder or s.Stack
elseif o and o.Root then
t=o.Root
elseif o and o.Instance then
t=o.Instance
else
t=o
end

local u=c.Frame(t,{
name=q.name or"TabGroup",
size=UDim2.new(1,0,0,0),
transparency=0,
color=r.window.card or r.window.foreground,
block="window",
key="element",
clips=true,
})
c.roundRect(u,8)


local v=c.Frame(u,{
name="Top",
size=UDim2.new(1,-0,0,36),
position=UDim2.fromOffset(0,4),
transparency=1,
})

local w=c.Frame(u,{
name="Body",
size=UDim2.new(1,0,1,-40),
position=UDim2.fromOffset(0,40),
transparency=1,
clips=true,
})
local x=Instance.new"UIListLayout"
x.Name="KronosStack"
x.SortOrder=Enum.SortOrder.LayoutOrder
x.Padding=UDim.new(0,8)
x.Parent=w

local y={
Root=u,
Stack=w,
Holder=w,
Top=v,
Tabs={},
window=n,
parent=o,
}


local function resize()
u.Size=UDim2.new(1,0,0,w.AbsoluteSize.Y+46)
end
w:GetPropertyChangedSignal"AbsoluteSize":Connect(function()
task.defer(resize)
end)
task.defer(resize)

function y.CreateTab(z,A)
A=A or{}
local B=c.Frame(w,{
name="Sub_"..tostring(A.name or"Sub"),
size=UDim2.new(1,0,0,0),
transparency=1,
clips=false,
})
local C=c.Frame(B,{
name="Stack",
size=UDim2.new(1,0,0,0),
transparency=1,
clips=false,
})
local D=Instance.new"UIListLayout"
D.Name="KronosStack"
D.SortOrder=Enum.SortOrder.LayoutOrder
D.Padding=UDim.new(0,8)
D.Parent=C
B:GetPropertyChangedSignal"AbsoluteSize":Connect(function()
C.Size=UDim2.new(1,0,0,B.AbsoluteSize.Y)
task.defer(resize)
end)

local E={
name=A.name or"Sub",
Root=B,
Stack=C,
Holder=C,
window=z,
}
y.Tabs[#y.Tabs+1]=E


local F=c.Button(v,{
name="Sub_btn_"..E.name,
size=UDim2.new(0,0,0,26),
text=E.name,
textSize=12,
transparency=0,
color=r.window.card or r.window.foreground,
block="window",
key="element",
})
F.Position=UDim2.fromOffset(#y.Tabs==1 and 8 or(8+(#y.Tabs-1)*100),5)
c.roundRect(F,6)
E.Button=F
F.MouseButton1Click:Connect(function()
y:SelectTab(E)
end)

if#y.Tabs==1 then
y:SelectTab(E)
end
return attachBuilders(z,E)
end

function y.SelectTab(z,A)
for B,C in ipairs(y.Tabs)do
C.Root.Visible=C==A
if C.Button then
C.Button.BackgroundColor3=C==A and r.accent.color or(r.window.card or r.window.foreground)
end
end
end

if q.tabs then
for z,A in ipairs(q.tabs)do
y:CreateTab(A)
end
end

n.containers[#n.containers+1]=y
return attachBuilders(n,y)
end


function l.packContainers(n,o)

end




function l.MakeColumn(n,o,q)
q=q or{}
local r=q.grid or 1 local s=

q.layout

local t
if o.Holder then
t=o.Holder
elseif o.Stack then
t=o.Stack
else
t=o.Root or o.Instance or o
end

local u=c.Frame(t,{
name="Column",
size=q.width or(r==1 and UDim2.new(1,0,0,0)or UDim2.new(1/r,0,0,0)),
transparency=1,
clips=false,
})
local v=c.Frame(u,{
name="Holder",
size=UDim2.fromScale(1,1),
transparency=1,
clips=false,
})
local w=Instance.new"UIListLayout"
w.Name="KronosList"
w.SortOrder=Enum.SortOrder.LayoutOrder
w.Padding=UDim.new(0,8)
w.Parent=v

local x={
Root=u,
Holder=v,
Layout=w,
Add=function(x,y)
x.LayoutOrder=y
x.Parent=v
return x
end,
}

local function resize()
u.Size=q.size or(r==1 and UDim2.new(1,0,0,v.AbsoluteSize.Y)or UDim2.new(1/r,0,0,v.AbsoluteSize.Y))
end
v:GetPropertyChangedSignal"AbsoluteSize":Connect(function()
task.defer(resize)
end)
task.defer(resize)

return attachBuilders(n,x)
end

local function LayoutSection(n,o)
o=normalizeOpts(o)
o.name=o.title or o.name
return e.Section(containerInstance(n)or n,o)
end

function l.CreateSection(n,o,q)
local r=LayoutSection(o,q)
attachBuilders(n,r)
r.window=n
return r
end

function l.CreateGroupbox(n,o,q)
q=normalizeOpts(q)
q.name=q.title or q.name
local r=e.Groupbox(containerInstance(o)or o,q)
attachBuilders(n,r)
r.window=n
return r
end





local function elementRowBuilder(n,o)
return function(q,r)
local s=asContainer(q,n)
local t=s and(s.Holder or s.Stack)
local u=g[o]{
parent=t or q,
opts=r,
window=n,
}
if s and s.Add then
s:Add(u.Instance)
end
if r and(r.flag or r.name)then
i.register(u)
end
if n.opts and n.opts.configuration and u.ValueSource then
if n.config then
n.config:autoRegister(u)
end
end
return u
end
end

function l.getSpecialItems(n,o)
if o=="player"then
local q={}
for r,s in ipairs(k:GetPlayers())do
table.insert(q,{title=s.Name..(s.DisplayName and(" ("..s.DisplayName..")")or""),icon="user",value=s})
end

n.playerItems=q
return q
elseif o=="team"then
local q={}
for r,s in ipairs(k:GetPlayers())do
q[#q+1]={title=s.Name,value=s}
end
return q
end
return{}
end


function l.CreateButton(n,o,q)
return elementRowBuilder(n,"Button")(o,q)
end
function l.CreateToggle(n,o,q)
return elementRowBuilder(n,"Toggle")(o,q)
end
function l.CreateSlider(n,o,q)
return elementRowBuilder(n,"Slider")(o,q)
end
function l.CreateSliderGroup(n,o,q)
return elementRowBuilder(n,"SliderGroup")(o,q)
end
function l.CreateDropdown(n,o,q)
return elementRowBuilder(n,"Dropdown")(o,q)
end
function l.CreateInput(n,o,q)
return elementRowBuilder(n,"Input")(o,q)
end
function l.CreateNumberInput(n,o,q)
return elementRowBuilder(n,"NumberInput")(o,q)
end
function l.CreateTextarea(n,o,q)
return elementRowBuilder(n,"Textarea")(o,q)
end
function l.CreateKeybind(n,o,q)
return elementRowBuilder(n,"Keybind")(o,q)
end
function l.CreateColorpicker(n,o,q)
return elementRowBuilder(n,"Colorpicker")(o,q)
end
function l.CreateLabel(n,o,q)
return elementRowBuilder(n,"Label")(o,q)
end
function l.CreateParagraph(n,o,q)
return elementRowBuilder(n,"Paragraph")(o,q)
end
function l.CreateDivider(n,o,q)
return elementRowBuilder(n,"Divider")(o,q)
end
function l.CreateSpace(n,o,q)
return elementRowBuilder(n,"Space")(o,q)
end
function l.CreateStat(n,o,q)
return elementRowBuilder(n,"Stat")(o,q)
end
function l.CreateCode(n,o,q)
return elementRowBuilder(n,"Code")(o,q)
end
function l.CreateImage(n,o,q)
return elementRowBuilder(n,"Image")(o,q)
end
function l.CreateTag(n,o,q)
return elementRowBuilder(n,"Tag")(o,q)
end
function l.CreateWatermark(n,o,q)
return elementRowBuilder(n,"Watermark")(o,q)
end
function l.CreateCodeblock(n,o,q)
return elementRowBuilder(n,"Code")(o,q)
end




function l.Splash(n,o)
o=o or{}
local q=theme()
local r=c.Frame(n.screen,{
name="Splash",
size=UDim2.fromScale(1,1),
transparency=0,
color=q.overlay.splash,
block="overlay",
key="splash",
zIndex=50,
clips=true,
})
c.roundRect(r,0)

c.IconLabel(r,{
icon=o.logo or o.icon or"settings",
size=UDim2.fromOffset(80,80),
position=UDim2.new(0.5,-40,0.5,-70),
color=q.accent.color,
textSize=64,
})
c.Label(r,{
size=UDim2.new(1,0,0,40),
position=UDim2.new(0,0,0.5,10),
text=o.name or n.opts.title or"Kronos",
textSize=26,
color=q.text.window,
x=Enum.TextXAlignment.Center,
font=Enum.Font.Code,
})
local s=o.status or"stable"
local t=s=="patched"and q.status.error or(s=="unstable"and q.status.warning or q.status.success)
c.Label(r,{
size=UDim2.new(1,0,0,24),
position=UDim2.new(0,0,0.5,52),
text=s:upper(),
textSize=13,
color=t,
x=Enum.TextXAlignment.Center,
})


if o.socials then
local u=#o.socials local v=
u*104
for w,x in ipairs(o.socials)do
local y=x.size=="large"and UDim2.fromOffset(120,32)or UDim2.fromOffset(90,28)
local z=x.size=="large"and 120 or 90 local A=
(u-w)*-100
local B=c.Button(r,{
size=UDim2.fromOffset(z,y.Y.Offset),
position=UDim2.new(0.5,z/2+(u-w)*-z-z,0.5,86),
anchor=Vector2.new(0.5,0),
text=x.name,
textSize=12,
transparency=0,
color=q.window.carry,
hover=q.accent.color,
block="window",
key="carry",
})
c.roundRect(B,8)
B.MouseButton1Click:Connect(function()
if x.link and getgenv().setclipboard then
pcall(getgenv().setclipboard,x.link)
B.Text="Copied!"
task.defer(function()
task.wait(0.8)
B.Text=x.name
end)
end
end)
end
end

n.splash=r
if o.onLoaded then
task.defer(o.onLoaded)
end
if o.autoDismiss~=false then
task.delay((o.duration or 1.5),function()
if r and r.Parent then
b.tween(r,TweenInfo.new(0.3),{BackgroundTransparency=1})
task.delay(0.3,function()
r:Destroy()
end)
end
end)
end
return r
end

function l.Notify(n,o)
o=o or{}
local q=theme()
local r=o.variant or"toast"
local s=q.notification[r]or q.chromium.topbar

local t=c.Frame(n.screen,{
name="Notify",
size=UDim2.fromOffset(320,0),
position=UDim2.new(1,-330,0,-20),
anchor=Vector2.new(1,1),
transparency=0,
color=r=="toast"and q.notification.toast or q.window.carry,
block="notification",
key=r=="toast"and"toast"or"info",
clips=true,
zIndex=40,
})
c.roundRect(t,12)

local u=c.Frame(t,{
name="Accent",
size=UDim2.fromOffset(4,1),
transparency=0,
color=s,
clips=false,
})
u.AnchorPoint=Vector2.new(0,0)

c.Label(t,{
name="Title",
size=UDim2.new(1,-24,0,20),
position=UDim2.fromOffset(14,10),
text=o.title or"",
textSize=13,
color=q.text.notification,
x=Enum.TextXAlignment.Left,
})

local v=c.Label(t,{
name="Content",
size=UDim2.new(1,-28,0,18),
position=UDim2.fromOffset(14,32),
text=o.content or"",
textSize=12,
color=q.text.desc,
wrap=true,
x=Enum.TextXAlignment.Left,
})


local w=60
if o.actions then
for x,y in ipairs(o.actions)do
local z=c.Button(t,{
name="Action",
size=UDim2.fromOffset(math.min(100,320/#o.actions-8),26),
position=UDim2.new(0,14+(x-1)*110,0,56),
text=y.label,
textSize=12,
transparency=0,
color=y.tone=="primary"and q.accent.color or q.window.carry2,
block="window",
key="carry2",
})
c.roundRect(z,8)
z.MouseButton1Click:Connect(function()
if y.callback then
pcall(y.callback)
end
t:Destroy()
end)
w=90
end
v.Position=UDim2.fromOffset(14,30)
end

t.Size=UDim2.fromOffset(320,w)local x=


t.Position
UDim2.new(1,-330,1,-20-(n._notifyCount or 0)*(w+10))
n._notifyCount=(n._notifyCount or 0)+1
t.Position=UDim2.new(1,-330,1,-w-10-(n._notifyCount-1)*(w+10))


local y=o.duration or 4
if o.duration~=nil and o.duration<=0 then
return t
end
task.delay(y,function()
if t and t.Parent then
b.tween(t,TweenInfo.new(0.3),{BackgroundTransparency=1})
task.delay(0.3,function()
t:Destroy()
n._notifyCount=math.max(0,(n._notifyCount or 1)-1)
end)
end
end)
return t
end

function l.Dialog(n,o)
o=o or{}
local q=theme()
local r=c.Frame(n.screen,{
name="DialogDim",
size=UDim2.fromScale(1,1),
transparency=1,
color=q.overlay.dialog,
block="overlay",
key="dialog",
zIndex=45,
})
r.BackgroundTransparency=1-(1-q.overlay.dim)

local s=c.Frame(r,{
name="Dialog",
size=UDim2.fromOffset(360,0),
position=UDim2.fromScale(0.5,0.5),
anchor=Vector2.new(0.5,0.5),
transparency=0,
color=q.overlay.dialog,
block="overlay",
key="dialog",
clips=true,
})
c.roundRect(s,14)

c.Label(s,{
size=UDim2.new(1,-40,0,40),
position=UDim2.fromOffset(20,14),
text=o.title or"",
textSize=16,
color=q.text.title,
x=Enum.TextXAlignment.Left,
})
c.Label(s,{
size=UDim2.new(1,-40,0,60),
position=UDim2.fromOffset(20,56),
text=o.content or"",
textSize=13,
color=q.text.desc,
wrap=true,
x=Enum.TextXAlignment.Left,
y=Enum.TextYAlignment.Top,
})

local t=o.buttons or{{text="OK",tone="primary"}}
local u=120
for v,w in ipairs(t)do
local x=(w.tone=="primary"and q.accent.color or w.tone=="destructive"and q.status.error or q.window.element)
local y=c.Button(s,{
size=UDim2.fromOffset(math.min(150,360/#t-12),32),
position=UDim2.new(0.5,0,1,-(16+(v-1)*40)),
anchor=Vector2.new(0.5,1),
text=w.text or"OK",
textSize=13,
transparency=0,
color=x,
hover=q.accent.hover,
block="window",
key="element",
})
c.roundRect(y,8)
y.MouseButton1Click:Connect(function()
if w.callback then
pcall(w.callback)
end
if o.onClose then
pcall(o.onClose)
end
r:Destroy()
end)
u=u+44
end
s.Size=UDim2.fromOffset(360,u+24)

r.InputBegan:Connect(function(v)
if v.UserInputType==Enum.UserInputType.MouseButton1 then

end
end)
return r
end




function l.minimize(n)
if n.opts.onMinimize then
pcall(n.opts.onMinimize)
return
end
n.Root.Visible=false
task.delay(0.05,function()
n.Root.Visible=true
end)
end

function l.setAlwaysOnTop(n,o)
n.alwaysOnTop=o
if n.opts.onAlwaysOnTopToggle then
pcall(n.opts.onAlwaysOnTopToggle,o)
end
end

function l.onResize(n)

end

function l.SetScale(n,o)
if o then
b.Scale.Set(o)
end
end

function l.SetAcrylic(n,o)
n.acrylic=o
if n.opts.onAcrylicToggle then
pcall(n.opts.onAcrylicToggle,o)
end
end

function l.CreateOpenButton(n,o)
if n.hasOpenButton then
return
end
n.hasOpenButton=true
o=o or{}
local q=theme()
local r=c.Frame(n.screen,{
name="OpenButton",
size=UDim2.fromOffset(o.size or 46,o.size or 46),
position=o.position or UDim2.new(0,20,0.5,0),
transparency=0,
color=q.accent.color,
block="accent",
key="color",
zIndex=5,
clips=true,
})
c.roundRect(r,14)
c.IconLabel(r,{
icon=o.icon or"settings",
size=UDim2.fromScale(1,1),
color=Color3.new(1,1,1),
})
r.InputBegan:Connect(function(s)
if s.UserInputType==Enum.UserInputType.MouseButton1 then
n.Root.Visible=not n.Root.Visible
if n.Root.Visible and n.splash and n.splash.Parent then
n.splash.Visible=true
task.delay(0.2,function()
if n.splash and n.splash.Parent then
n.splash.Visible=false
end
end)
end
end
end)


r.InputBegan:Connect(function(s)
if s.UserInputType==Enum.UserInputType.MouseButton1 or s.UserInputType==Enum.UserInputType.Touch then
local t=s.Position
local u=r.Position
local v=b.UserInputService.InputChanged:Connect(function(v)
if v.UserInputType==Enum.UserInputType.MouseMovement or v.UserInputType==Enum.UserInputType.Touch then
r.Position=u+UDim2.fromOffset(v.Position.X-t.X,v.Position.Y-t.Y)
end
end)
b.UserInputService.InputEnded:Connect(function()
v:Disconnect()
ended:Disconnect()
end)
end
end)

n.openButton=r
return r
end

function l.CreateGlobalSetting(n,o)
local q=theme()
local r=n.Rail
r.Visible=true

local s=c.Button(r,{
name="GS_"..(o.name or"setting"),
size=UDim2.fromOffset(28,28),
position=UDim2.new(0.5,-14,0,#n.globalSettings*34+6),
text=h.nameToGlyph(o.icon)or"•",
textSize=13,
transparency=0,
color=(o.default and q.accent.color or q.window.carry2),
block="window",
key="carry2",
zIndex=4,
x=Enum.TextXAlignment.Center,
})
c.roundRect(s,7)
local t=o.default or false
n.globalSettings[#n.globalSettings+1]={
opts=o,
value=t,
btn=s,
}
s.MouseButton1Click:Connect(function()
t=not t
s.BackgroundColor3=t and q.accent.color or q.window.carry2
table.insert(n.globalSettings,n.globalSettings[#n.globalSettings])
if o.callback then
pcall(o.callback,t)
end
end)
return{
Set=function(u,v)
t=v
s.BackgroundColor3=v and q.accent.color or q.window.carry2
if o.callback then
pcall(o.callback,v)
end
end,
Get=function()
return t
end,
btn=s,
}
end


function l.openConfigPopup(n,o)
local q=theme()
local r=c.Frame(n.screen,{
name="ConfigDim",
size=UDim2.fromScale(1,1),
transparency=1,
color=q.overlay.dialog,
block="overlay",
key="dialog",
zIndex=44,
})
r.BackgroundTransparency=1-(1-q.overlay.dim)
r.InputBegan:Connect(function(s)
if s.UserInputType==Enum.UserInputType.MouseButton1 then
r:Destroy()
end
end)

local s=c.Frame(r,{
name="ConfigPopup",
size=UDim2.fromOffset(280,150),
position=UDim2.fromScale(0.5,0.5),
anchor=Vector2.new(0.5,0.5),
transparency=0,
color=q.overlay.popup,
block="overlay",
key="popup",
clips=true,
})
c.roundRect(s,12)

c.Label(s,{
size=UDim2.new(1,-28,0,30),
position=UDim2.fromOffset(14,10),
text=(o.name or"Element").." — Config",
textSize=14,
color=q.text.title,
})
c.Label(s,{
size=UDim2.new(1,-28,0,20),
position=UDim2.fromOffset(14,42),
text="Flag: "..(o.name or"-"),
textSize=12,
color=q.text.desc,
})
c.Label(s,{
size=UDim2.new(1,-28,0,20),
position=UDim2.fromOffset(14,62),
text="Value: "..tostring(o.value~=nil and o.value or"-"),
textSize=12,
color=q.text.desc,
})
local t=c.Button(s,{
size=UDim2.fromOffset(80,26),
position=UDim2.new(1,-90,1,-12),
text="Done",
textSize=12,
transparency=0,
color=q.accent.color,
hover=q.accent.hover,
block="accent",
key="color",
})
c.roundRect(t,7)
t.MouseButton1Click:Connect(function()
r:Destroy()
end)
return r
end

function l.Destroy(n)
if n.drag then
n.drag:DestroyDrag()
end
if n.Root and n.Root.Parent then
n.Root:Destroy()
end
end

l.destroy=l.Destroy

return l end function a.n():typeof(__modImpl())local b=a.cache.n if not b then b={c=__modImpl()}a.cache.n=b end return b.c end end do local function __modImpl()





local b=a.a()

local c={}

c.providers={}

local function readSavedKey(d,e)
if not b.fs.readFile then
return nil
end
local f=b.fs.supported and"workspace/Kronos/keys"or nil
if not f then
return nil
end
local g=f.."/"..tostring(e and(e.fileName or e.keyFile)or"key")..".txt"
local h,i=b.fs.readFile(g)
if h then
return i:gsub("%s+","")
end
return nil
end

local function saveKey(d,e)
if not b.fs.supported then
return
end
local f="workspace/Kronos/keys"
b.fs.ensureFolder(f)
local g=f.."/"..tostring(e and(e.fileName or e.keyFile)or"key")..".txt"
pcall(b.fs.writeFile,g,d)
end








local d={}

function d.New(e)
e=e or{}
local f=e.apiBase or"https://api.jnkie.com/api/v2"

local g={
Name="JNKIE",
Icon="key",
}

local h=readSavedKey(g,e)

function g.Verify(i,j)
local k=j or e.key or h
if not k then
return false,"key:no_key",nil
end

local l=f.."/keys/verify"
local m=b.encode{
key=k,
}
local n,o=b.request{
Url=l,
Method="POST",
Headers={
["Content-Type"]="application/json",
},
Body=m,
}
if not n then
return false,"key:network",o
end
if n.StatusCode and n.StatusCode>=200 and n.StatusCode<300 then
local q=b.decode(n.Body)
local r=q and q.valid or false
if r and e.saveKey~=false then
saveKey(k,e)
end
return r,r and"key:valid"or(q and q.reason or"key:invalid")
end

if h then
return true,"key:saved-fallback"
end
return false,"key:http-"..tostring(n.StatusCode or"?")
end

function g.Copy(i)

local j=b.getgenv()and b.getgenv().setclipboard
if e.flowUrl then
pcall(j,e.flowUrl)
return e.flowUrl
end
return nil
end

function g.GetKey(i)
return e.key or h
end

return g
end

c.providers.jnkie=d
c.providers.JNKIE=d




local e={}
function e.New(f)
local g={
Name=f.name or"Key",
Icon=f.icon or"key",
}
function g.Verify(h,i)
if f.verify then
return f.verify(i)
end
return false,"key:no-verifier"
end
function g.Copy(h)
if f.copy and getgenv().setclipboard then
pcall(getgenv().setclipboard,f.copy)
end
end
return g
end


function c.register(f,g)
c.providers[f]=g
end

function c.get(f)
return c.providers[f or"jnkie"]
end

c.GENERIC=e
return c end function a.o():typeof(__modImpl())local b=a.cache.o if not b then b={c=__modImpl()}a.cache.o=b end return b.c end end end





local b=a.a()a.e()

local c=a.c()
local d=a.b()
local e=a.n()
local f=a.i()
local g=a.l()
local h=a.m()
local i=a.o()
local j=a.h()

local k={}
k.VERSION="1.0.0"
k.Name="Kronos"




local l={}

function k.CreateWindow(m,n)
n=n or{}
local o=n.Icon or n.screen
if not o then
local q=b.getgenv()
if q and q.gethui then
local r,s=pcall(q.gethui)
if r and s then
o=s
end
end
end
if not o then
o=gethui and gethui()or game:GetService"CoreGui"
end

local q=e.new(o,n)
table.insert(l,q)
return q
end

function k.GetWindows(m)
return l
end




function k.Notify(m,n)
if#l>0 then
return l[#l]:Notify(n)
end
return nil
end

function k.Dialog(m,n)
if#l>0 then
return l[#l]:Dialog(n)
end
return nil
end

function k.Splash(m,n)
if#l>0 then
return l[#l]:Splash(n)
end
return nil
end




function k.AddTheme(m,n,o)
c.Add(n,o)
return true
end

function k.SetTheme(m,n)
return c.Apply(n)
end

function k.GetTheme(m)
return c.currentName
end

function k.GetThemeList(m)
return c.List()
end




k.Config=h
k.ConfigManager=h.ConfigManager
k.Keys=i
k.I18n=j

k.Services={
Keys=i,
I18n=j,
}


k.UI={
GetScale=b.getScale,
IsDesktop=b.isDesktop,
SecureMode=b.SecureMode,
ZeroAsset=b.zeroAsset,
}


k.Value=d.Value
k.Batch=d.Batch


k.Registry=f
k.Elements=g

function k.Log(m,n,o)
local q="[Kronos] "
if o=="warn"then
q=q.."[warn] "
elseif o=="error"then
q=q.."[error] "
end
q=q..tostring(n)
if b.isStudio then
warn(q)
else
print(q)
end
end


function k.Unload(m)
for n,o in ipairs(l)do
pcall(function()
o:destroy()
end)
end
l={}
end

return k
