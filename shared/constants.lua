---@class constants
constants = {}

--- Identifier types
constants.identifierTypes = {
    'license',
    'license2',
    'steam',
    'xbl',
    'live',
    'discord',
    'fivem',
    'ip'
}

--- Discord colors
constants.colors = {
    green = 3066993,
    grey = 9807270,
    red = 15158332,
    orange = 15105570,
    blue = 3447003,
    purple = 10181046,
    yellow = 15844367
}

--- Character to bold character table
constants.boldFonts = {
    ['a'] = '𝗮', ['b'] = '𝗯', ['c'] = '𝗰', ['d'] = '𝗱', ['e'] = '𝗲', ['f'] = '𝗳', ['g'] = '𝗴',
    ['h'] = '𝗵', ['i'] = '𝗶', ['j'] = '𝗷', ['k'] = '𝗸', ['l'] = '𝗹', ['m'] = '𝗺', ['n'] = '𝗻',
    ['o'] = '𝗼', ['p'] = '𝗽', ['q'] = '𝗾', ['r'] = '𝗿', ['s'] = '𝘀', ['t'] = '𝘁', ['u'] = '𝘂',
    ['v'] = '𝘃', ['w'] = '𝘄', ['x'] = '𝘅', ['y'] = '𝘆', ['z'] = '𝘇', ['A'] = '𝗔', ['B'] = '𝗕',
    ['C'] = '𝗖', ['D'] = '𝗗', ['E'] = '𝗘', ['F'] = '𝗙', ['G'] = '𝗚', ['H'] = '𝗛', ['I'] = '𝗜',
    ['J'] = '𝗝', ['K'] = '𝗞', ['L'] = '𝗟', ['M'] = '𝗠', ['N'] = '𝗡', ['O'] = '𝗢', ['P'] = '𝗣',
    ['Q'] = '𝗤', ['R'] = '𝗥', ['S'] = '𝗦', ['T'] = '𝗧', ['U'] = '𝗨', ['V'] = '𝗩', ['W'] = '𝗪',
    ['X'] = '𝗫', ['Y'] = '𝗬', ['Z'] = '𝗭', ['1'] = '𝟭', ['2'] = '𝟮', ['3'] = '𝟯', ['4'] = '𝟰',
    ['5'] = '𝟱', ['6'] = '𝟲', ['7'] = '𝟳', ['8'] = '𝟴', ['9'] = '𝟵', ['0'] = '𝟬'
}

constants.mapperIds = {
    'DIGITALBUTTON_AXIS',
    'GAME_CONTROLLED',
    'JOYSTICK_AXIS',
    'JOYSTICK_AXIS_NEGATIVE',
    'JOYSTICK_AXIS_POSITIVE',
    'JOYSTICK_BUTTON',
    'JOYSTICK_IAXIS',
    'JOYSTICK_POV',
    'JOYSTICK_POV_AXIS',
    'KEYBOARD',
    'MKB_AXIS',
    'MOUSE_ABSOLUTEAXIS',
    'MOUSE_BUTTON',
    'MOUSE_BUTTONANY',
    'MOUSE_CENTEREDAXIS',
    'MOUSE_RELATIVEAXIS',
    'MOUSE_SCALEDAXIS',
    'MOUSE_NORMALIZED',
    'MOUSE_WHEEL',
    'PAD_ANALOGBUTTON',
    'PAD_AXIS',
    'PAD_DEBUGBUTTON',
    'PAD_DIGITALBUTTON',
    'PAD_DIGITALBUTTONANY',
    'TOUCHPAD_ABSOLUTE_AXIS',
    'TOUCHPAD_CENTERED_AXIS'
}

constants.aces = {
    job = {
        all = 'jobace',
        buy = {
            all = 'jobace.buy',
            weapons = 'jobace.buy.weapons',
            items = 'jobace.buy.items',
            vehicles = 'jobace.buy.vehicles'
        },
        sell = {
            all = 'jobace.sell',
            weapons = 'jobace.sell.weapons',
            items = 'jobace.sell.items',
            vehicles = 'jobace.sell.vehicles'
        },
        action = {
            all = 'jobace.action',
            handcuff = 'jobace.action.handcuff',
            hostage = 'jobace.action.hostage',
            drag = 'jobace.action.drag',
            invehicle = 'jobace.action.invehicle',
            outvehicle = 'jobace.action.outvehicle'
        },
        safe = {
            all = 'jobace.safe',
            wallet = {
                all = 'jobace.safe.wallet',
                add = 'jobace.safe.wallet.add',
                remove = 'jobace.safe.wallet.remove'
            },
            item = {
                all = 'jobace.safe.item',
                add = 'jobace.safe.item.add',
                remove = 'jobace.safe.item.remove'
            },
            weapon = {
                all = 'jobace.safe.weapon',
                add = 'jobace.safe.weapon.add',
                remove = 'jobace.safe.weapon.remove'
            }
        },
        wardrobe = 'jobace.wardrobe'
    }
}