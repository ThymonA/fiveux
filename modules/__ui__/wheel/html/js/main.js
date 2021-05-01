(() => {
    window.NUI_WHEEL = new Vue({
        el: '#nui_wheel',
        render: wheel => wheel({
            template: '#nui_wheel_template',
            name: 'NUI_WHEEL',
            data() {
                return {
                    id: 0,
                    hidden: true,
                    items: [],
                    x: 0,
                    y: 0,
                    mouseX: 0,
                    mouseY: 0,
                    chosen: 0
                }
            },
            mounted() {
                window.addEventListener('message', e => {
                    const item = e.data || e.detail;

                    if (this[item.action]) {
                        this[item.action](item);
                    }
                });

                window.addEventListener('mousemove', this.mousemove);
                window.addEventListener('touchmove', e => this.mousemove(e.touches[0]));
                window.addEventListener('mousedown', this.mousedown);
            
                this.postNUI('ready')
            },
            watch: {
                id() {},
                hidden() {},
                items: {
                    deep: true,
                    handler() {}
                },
                x() {},
                y() {}
            },
            methods: {
                SHOW({ id, items, x, y }) {
                    this.id = id || 0;
                    this.items = items || [];
                    this.x = x || 0;
                    this.y = y || 0;
                    this.hidden = false;
                    this.postNUI('show', { id: this.id })
                },
                HIDE() {
                    this.id = 0;
                    this.items = [];
                    this.x = 0;
                    this.y = 0;
                    this.hidden = true;
                    this.chosen = 0;
                    this.postNUI('hide')
                },
                itemover: function(e) {
                    const element = e.srcElement || null;

                    if (element != null && element.dataset != null && element.dataset.index != null) {
                        const currentIndex = this.itemindex(element.x, element.y);

                        if (currentIndex == element.dataset.index) {
                            this.chosen = element.dataset.index;
                        } else {
                            this.chosen = 0;
                        }
                    }
                },
                itemleave: function() {
                    this.chosen = 0
                },
                itemindex: function() {
                    if (this.hidden) { return 0; }

                    let dx = this.mouseX - this.x;
                    let dy = this.mouseY - this.y;
                    let mag = Math.sqrt(dx * dx + dy * dy);
                    let index = 0;
                
                    if (mag >= 100 && mag <= 205) {
                        let deg = Math.atan2(dy, dx) + 0.625 * Math.PI;
                        while (deg < 0) deg += Math.PI * 2;
                        index = Math.floor(deg / Math.PI * 4) + 1;
                    }

                    return index
                },
                mousemove: function({ x, y }) {
                    if (this.hidden) { return; }

                    this.mouseX = x;
                    this.mouseY = y;
                    this.chosen = this.itemindex();
                },
                mousedown: function(e) {
                    if (this.hidden) { return; }
                    if (e.which != 1) { return; }

                    this.postNUI('select', { id: this.id, chosen: this.chosen });

                    this.id = 0;
                    this.items = [];
                    this.x = 0;
                    this.y = 0;
                    this.hidden = true;
                    this.chosen = 0;
                },
                postNUI(event, info) {
                    event = event || 'unknown';
                    info = info || {};

                    return window.parent.postMessage({ event: event, info: info }, '*');
                }
            }
        })
    })
})();