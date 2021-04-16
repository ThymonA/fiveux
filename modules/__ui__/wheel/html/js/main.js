(() => {
    window.NUI_WHEEL = new Vue({
        el: '#nui_wheel',
        render: wheel => wheel({
            template: '#nui_wheel_template',
            name: 'NUI_WHEEL',
            data() {
                return {
                    id: 0,
                    hidden: false,
                    items: [
                        { id: 1, lib: 'las', icon: 'la-car' },
                        { id: 2, lib: 'las', icon: 'la-car-battery' },
                        { id: 3, lib: 'las', icon: 'la-car' },
                        { id: 4, lib: 'las', icon: 'la-car' }
                    ],
                    x: 320,
                    y: 320,
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
                    this.mouseX = x;
                    this.mouseY = y;
                    this.chosen = this.itemindex();
                },
                mousedown: function(e) {
                    if (e.which != 1) { return; }

                    
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