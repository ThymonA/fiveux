(() => {
    VueScrollTo.setDefaults({
        container: 'ul.menu-items',
        duration: 500,
        easing: 'ease-in',
        offset: -25,
        force: true,
        cancelable: false,
        onStart: false,
        onDone: false,
        onCancel: false,
        x: false,
        y: true
    });

    window.NUI_MENU_COMPONENT = Vue.component('v-style', {
        render: function(createElement) {
            return createElement('style', this.$slots.default);
        }
    });

    window.NUI_MENU = new Vue({
        el: '#nui_menu',
        render: menu => menu({
            template: '#nui_menu_template',
            name: 'NUI_MENU',
            components: {
                NUI_MENU_COMPONENT
            },
            data() {
                return {
                    RESOURCE_NAME: window.GetParentResourceName ? GetParentResourceName() : 'fiveux',
                    hidden: true,
                    id: 0,
                    title: '',
                    subtitle: '',
                    position: 'topleft',
                    red: 0,
                    green: 0,
                    blue: 0,
                    bannerUrl: '',
                    items: [],
                    index: 0,
                    size: 'size-125'
                }
            },
            mounted() {
                window.addEventListener('message', e => {
                    const item = e.data || e.detail;

                    if (this[item.action]) {
                        this[item.action](item);
                    }
                });
            
                this.postNUI('ready')
            },
            updated: function() {
                if (this.index < 0) { return; }
        
                const el = document.getElementsByTagName('li');
        
                for (var i = 0; i < el.length; i++) {
                    const index = el[i].getAttribute('index')
        
                    if (index === null) { continue; }
        
                    const idx = parseInt(index);
        
                    if (idx == this.index) {
                        this.$scrollTo(`li[index="${this.index}"]`, 0, {});
                    }
                }
            },
            watch: {
                hidden() {},
                id() {},
                title() {},
                subtitle() {},
                position() {},
                red() {},
                green() {},
                blue() {},
                bannerUrl() {},
                items: {
                    deep: true,
                    handler() {}
                },
                index() {}
            },
            methods: {
                OPEN({ id, title, subtitle, position, red, green, blue, bannerUrl, items, reloaded }) {
                    id = id || 0;
                    title = title || '';
                    subtitle = subtitle || '';
                    position = position || 'topleft';
                    red = red || 0;
                    green = green || 0;
                    blue = blue || 0;
                    bannerUrl = bannerUrl || '';
                    items = items || [];
                    reloaded = reloaded || false;

                    if (typeof id != 'number') { id = Number(id); }
                    if (typeof title != 'string') { title = String(title); }
                    if (typeof subtitle != 'string') { subtitle = String(subtitle); }
                    if (typeof position != 'string') { position = String(position); }
                    if (typeof red != 'number') { red = Number(red); }
                    if (typeof green != 'number') { green = Number(green); }
                    if (typeof blue != 'number') { blue = Number(blue); }
                    if (typeof bannerUrl != 'string') { bannerUrl = String(bannerUrl); }
                    if (typeof items != 'object' || !Array.isArray(items)) { items = []; }
                    if (typeof reloaded != 'boolean') { reloaded = Boolean(reloaded); }

                    if (!['topleft', 'topcenter', 'topright', 'centerleft', 'center', 'centeright', 'bottomleft', 'bottomcenter', 'bottomright'].includes(position)) {
                        position = 'topleft';
                    }

                    if (reloaded && this.id != id) { return; }
                    if (this.id != id || !reloaded) { this.index = 0; }

                    this.id = id;
                    this.title = title;
                    this.subtitle = subtitle;
                    this.position = position;
                    this.red = red;
                    this.green = green;
                    this.blue = blue;
                    this.bannerUrl = bannerUrl;
                    this.items = [];

                    for (var i = 0; i < items.length; i++) {
                        let index = items[i].index || 0;
                        let type = items[i].type || 'button';
                        let label = items[i].label || '';
                        let value = items[i].value || null;
                        let disabled = items[i].disabled || false;
                        let description = items[i].description || '';
                        let min = items[i].min || 0;
                        let max = items[i].max || 0;
                        
                        if (typeof index != 'number') { index = Number(index); }
                        if (typeof type != 'string') { type = String(type); }
                        if (typeof label != 'string') { label = String(label); }
                        if (typeof disabled != 'boolean') { disabled = Boolean(disabled); }
                        if (typeof description != 'string') { description = String(description); }
                        if (typeof min != 'number') { min = Number(min); }
                        if (typeof max != 'number') { max = Number(max); }
                        if (!['button', 'range', 'checkbox'].includes(type)) { type = 'button'; }
                        if (type == 'button' && typeof value != 'string') { value = String(value); }
                        if (type == 'range' && typeof value != 'number') { value = Number(value); }
                        if (type == 'checkbox' && typeof value != 'boolean') { value = Boolean(value); }

                        this.items.push({
                            index: index,
                            type: type,
                            label: label,
                            value: value,
                            disabled: disabled,
                            description: description,
                            min: min,
                            max: max
                        })
                    }

                    const nextIndex = this.NEXT_INDEX(this.index);

                    this.index = nextIndex;
                    this.hidden = false;

                    if (!reloaded) {
                        this.postNUI('open', { id: this.id });
                    }
                },
                CLOSE({ id }) {
                    id = id || 0;

                    if (typeof id != 'number') { id = Number(id); }
                    if (id != this.id) { return; }

                    const cachedIndex = id + 0;

                    this.id = 0;
                    this.title = '';
                    this.subtitle = '';
                    this.position = 'topleft';
                    this.red = 0;
                    this.green = 0;
                    this.blue = 0;
                    this.bannerUrl = '';
                    this.items = [];
                    this.hidden = true;
                    this.index = 0;

                    this.postNUI('close', { id: cachedIndex });
                },
                KEY_PRESSED({ key }) {
                    if (this.hidden) { return; }
        
                    const k = key
        
                    if (typeof k == 'undefined' || k == null) {
                        return
                    }
        
                    const keyRef = `KEY_${k}`;
        
                    if (this[keyRef]) {
                        this[keyRef]();
                    }
                },
                KEY_UP: function() {
                    const newIndex = this.PREV_INDEX(this.index);
        
                    if (this.index != newIndex) {
                        this.index = newIndex;
                    }
                },
                KEY_DOWN: function() {
                    const newIndex = this.NEXT_INDEX(this.index);
        
                    if (this.index != newIndex) {
                        this.index = newIndex;
                    }
                },
                KEY_LEFT: function() {
                    if (this.index < 0 || this.items.length <= this.index || this.items[this.index].disabled) { return; }
        
                    const item = this.items[this.index];
        
                    if (item.type == 'button' || item.type == 'label' || item.type == 'unknown') { return; }
        
                    switch(item.type) {
                        case 'checkbox':
                            const boolean_value = item.value;
        
                            this.items[this.index].value = !boolean_value;
                            this.postNUI('change', { id: this.id, index: item.index, value: boolean_value });
                            break;
                        case 'range':
                            let new_range_index = null;
                            let range_value = item.value;
        
                            if ((range_value - 1) <= item.min) { new_range_index = item.min; }
                            else if ((range_value - 1) >= item.max) { new_range_index = item.max; }
                            else { new_range_index = (this.items[this.index].value - 1); }
        
                            if (new_range_index != this.items[this.index].value) {
                                this.items[this.index].value = new_range_index;
                                this.postNUI('change', { id: this.id, index: item.index, value: new_range_index });
                            }
        
                            break;
                        default:
                            break;
                    }
                },
                KEY_RIGHT: function() {
                    if (this.index < 0 || this.items.length <= this.index || this.items[this.index].disabled) { return; }
        
                    const item = this.items[this.index];
        
                    if (item.type == 'button' || item.type == 'label' || item.type == 'unknown') { return; }
        
                    switch(item.type) {
                        case 'checkbox':
                            const boolean_value = item.value;
        
                            this.items[this.index].value = !boolean_value;
                            this.postNUI('change', { id: this.id, index: item.index, value: this.items[this.index].value });
                            break;
                        case 'range':
                            let new_range_index = null;
                            let range_value = item.value;
        
                            if ((range_value + 1) <= item.min) { new_range_index = item.min; }
                            else if ((range_value + 1) >= item.max) { new_range_index = item.max; }
                            else { new_range_index = (this.items[this.index].value + 1); }
        
                            if (new_range_index != this.items[this.index].value) {
                                this.items[this.index].value = new_range_index;
                                this.postNUI('change', { id: this.id, index: item.index, value: this.items[this.index].value });
                            }
                            break;
                        default:
                            break;
                    }
                },
                KEY_ENTER: function() {
                    if (this.index < 0 || this.items.length <= this.index || this.items[this.index].disabled) { return; }
        
                    const item = this.items[this.index];
        
                    switch(item.type) {
                        case 'button':
                            this.postNUI('submit', { id: this.id, index: item.index, value: null });
                            break;
                        case 'range':
                            let range_value = item.value;
        
                            if (range_value <= item.min) { range_value = item.min; }
                            else if (range_value >= item.max) { range_value = item.max; }
                            
                            this.items[this.index].value = range_value;
                            this.postNUI('submit', { id: this.id, index: item.index, value: this.items[this.index].value });
                            break;
                        case 'checkbox':
                            const boolean_value = item.value;
        
                            this.items[this.index].value = !boolean_value;
                            this.postNUI('submit', { id: this.id, index: item.index, value: this.items[this.index].value });
                            break;
                        default:
                            break;
                    }
                },
                KEY_CLOSE: function() {
                    this.CLOSE({ id: this.id });
                },
                postNUI(event, info) {
                    event = event || 'unknown';
                    info = info || {};

                    return window.parent.postMessage({ event: event, info: info }, '*');
                },
                FORMAT_TEXT: function(text) {
                    text = text || '';

                    if (typeof text != 'string') { text = String(text); }
        
                    text = text.replace(/\^0/g, '<span style="color: black !important;">');
                    text = text.replace(/\^1/g, '<span style="color: red !important;">');
                    text = text.replace(/\^2/g, '<span style="color: green !important;">');
                    text = text.replace(/\^3/g, '<span style="color: yellow !important;">');
                    text = text.replace(/\^4/g, '<span style="color: blue !important;">');
                    text = text.replace(/\^5/g, '<span style="color: cyan !important;">');
                    text = text.replace(/\^6/g, '<span style="color: purple !important;">');
                    text = text.replace(/\^7/g, '<span style="color: white !important;">');
                    text = text.replace(/\^8/g, '<span style="color: darkred !important;">');
                    text = text.replace(/\^9/g, '<span style="color: gray !important;">');
                    text = text.replace(/~r~/g, '<span style="color: red !important;">');
                    text = text.replace(/~g~/g, '<span style="color: green !important;">');
                    text = text.replace(/~b~/g, '<span style="color: blue !important;">');
                    text = text.replace(/~y~/g, '<span style="color: yellow !important;">');
                    text = text.replace(/~p~/g, '<span style="color: purple !important;">');
                    text = text.replace(/~c~/g, '<span style="color: gray !important;">');
                    text = text.replace(/~m~/g, '<span style="color: darkgray !important;">');
                    text = text.replace(/~u~/g, '<span style="color: black !important;">');
                    text = text.replace(/~o~/g, '<span style="color: orange !important;">');
                    text = text.replace(/~n~/g, '<br />');
                    text = text.replace(/~s~/g, '<span style="color: white !important;">');
                    text = text.replace(/~h~/g, '<strong>');
        
                    const d = new DOMParser();
                    const domObj = d.parseFromString(text || "", "text/html");
                    
                    return domObj.body.innerHTML;
                },
                NL2BR: function(text, replaceMode, isXhtml) {
                    var breakTag = (isXhtml) ? '<br />' : '<br>';
                    var replaceStr = (replaceMode) ? '$1'+ breakTag : '$1'+ breakTag +'$2';
        
                    return (text + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, replaceStr);
                },
                GET_CURRENT_DESCRIPTION: function() {
                    const index = this.index || 0;

                    if (index >= 0 && index < this.items.length) {
                        return this.FORMAT_TEXT(this.NL2BR(this.items[index].description, true, false));
                    }

                    return '';
                },
                TEXT_COLOR: function(r, g, b, o) {
                    o = o || 1.0
        
                    if (o > 1.0) { o = 1.0; }
                    if (o < 0.0) { o = 0.0; }
        
                    const luminance = ( 0.299 * r + 0.587 * g + 0.114 * b)/255;
        
                    if (luminance > 0.5) {
                        return `rgba(0, 0, 0, ${o})`;
                    }
        
                    return `rgba(255, 255, 255, ${o})`;
                },
                NEXT_INDEX: function(idx) {
                    if (idx == null || typeof idx == "undefined") { idx = this.index; }
                
                    let index = 0;
                    let newIndex = -2;
        
                    if (this.items.length <= 0) { return -1; }
        
                    while (newIndex < -1) {
                        if ((idx + 1 + index) < this.items.length) {
                            if (!this.items[(idx + 1 + index)].disabled) {
                                newIndex = (idx + 1 + index);
                            } else {
                                index++;
                            }
                        } else if (index >= this.items.length) {
                            return -1;
                        } else {
                            const addIndex = (idx + 1 + index) - this.items.length;
        
                            if (addIndex < this.items.length) {
                                if (!this.items[addIndex].disabled) {
                                    newIndex = addIndex;
                                } else {
                                    index++;
                                }
                            } else {
                                index++;
                            }
                        }
                    }
        
                    if (newIndex < 0) { return -1; }
        
                    return newIndex;
                },
                PREV_INDEX: function(idx) {
                    if (idx == null || typeof idx == "undefined") { idx = this.index; }
        
                    let index = 0;
                    let newIndex = -2;
        
                    if (this.items.length <= 0) { return -1; }
        
                    while (newIndex < -1) {
                        if ((idx - 1 - index) >= 0) {
                            if (!this.items[(idx - 1 - index)].disabled) {
                                newIndex = (idx - 1 - index);
                            } else {
                                index++;
                            }
                        } else if (index >= this.items.length) {
                            return -1;
                        } else {
                            const addIndex = (idx - 1 - index) + this.items.length;
        
                            if (addIndex < this.items.length && addIndex >= 0) {
                                if (!this.items[addIndex].disabled) {
                                    newIndex = addIndex;
                                } else {
                                    index++;
                                }
                            } else {
                                index++;
                            }
                        }
                    }
        
                    if (newIndex < 0) { return -1; }
        
                    return newIndex;
                }
            }
        })
    })
})();