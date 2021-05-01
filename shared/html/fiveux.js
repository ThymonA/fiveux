(() => {
    class FXRoot {
        constructor() {
            this.frames = {};
            this.resName = GetParentResourceName();

            window.addEventListener('message', e => {
                for (let name in this.frames) {
                    if (this.frames[name].iframe.contentWindow === e.source) {
                        const data = e.data || e.detail;
                        const event = data.event || 'unknown';
                        const info = data.info || {};

                        this.postFrameMessage(name, event, info);
                        return;
                    }
                }

                this.onMessage(e.data);
            });

            this.NUICallback('nui_ready');
        }

        async NUICallback(name, data = {}, asJSON = false) {
            const res = await fetch('https://' + this.resName + '/' + name, {
                method: 'POST',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            });

            if (asJSON)
                return res.json();
            else
                return res.text();

        }

        createFrame(name, url, visible = true) {
            if (this.frames[name]) { return; }

            const frame = document.createElement('div');
            const iframe = document.createElement('iframe');

            frame.appendChild(iframe);

            iframe.src = url;
            this.frames[name] = {
                frame,
                iframe,
                url
            };

            this.frames[name].iframe.addEventListener('message', e => this.onFrameMessage(name, e.data));
            this.frames[name].frame.style.pointerEvents = 'none';

            document.querySelector('#frames').appendChild(frame);

            if (!visible)
                this.hideFrame(name);

            this.frames[name].iframe.contentWindow.addEventListener('DOMContentLoaded', () => {
                this.NUICallback('frame_load', {
                    name
                });
            }, true);

            return this.frames[name];
        }

        destroyFrame(name) {
            this.frames[name].iframe.remove();
            this.frames[name].frame.remove();
            delete this.frames[name];
        }

        showFrame(name) {
            this.frames[name].frame.style.display = 'block';
        }

        hideFrame(name) {
            this.frames[name].frame.style.display = 'none';
        }

        focusFrame(name) {
            for (let k in this.frames) {
                if (k === name)
                    this.frames[k].frame.style.pointerEvents = 'all';
                else
                    this.frames[k].frame.style.pointerEvents = 'none';
            }

            this.frames[name].iframe.contentWindow.focus();
        }

        resetFocus() {
            for (let k in this.frames) {
                this.frames[k].frame.style.pointerEvents = 'none';
                this.frames[k].iframe.contentWindow.blur();
            }

            window.focus();
        }

        onMessage(msg) {
            if (msg.target) {
                if (this.frames[msg.target])
                    this.frames[msg.target].iframe.contentWindow.postMessage(msg.data);
                else
                    console.error('[fx:nui] cannot find frame : ' + msg.target);
            } else {
                switch (msg.action) {
                    case 'create_frame': { this.createFrame(msg.name, msg.url, msg.visible); break; }
                    case 'destroy_frame': { this.destroyFrame(msg.name); break; }
                    case 'focus_frame': { this.focusFrame(msg.name); break; }
                    case 'show_frame': { this.showFrame(msg.name); break; }
                    case 'hide_frame': { this.hideFrame(msg.name); break; }
                    case 'reset_focus': {this.resetFocus(); break; }
                    default: break;
                }
            }
        }

        postFrameMessage(name, event, msg) {
            this.NUICallback('frame_message', { name, event, msg })
        }
    }

    window.__FXROOT__ = window.__FXROOT__ || new FXRoot();
})();