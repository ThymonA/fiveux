(() => {
    class iFRAMEROOT {
        constructor() {
            this.frames  = {};
            this.RESOURCE_NAME = typeof GetParentResourceName !== 'undefined' ? GetParentResourceName() : 'fiveux';
            this.ENVIRONMENT = 'client';
            this.__NAME__ = 'global';
            this.__PRIMARY__ = 'global';

            window.addEventListener('message', e => {
                const data = e.data || e.detail || null;

                for (const name in this.frames) {
                    if (name === data.source) {
                        this.frames[name].iframe.contentWindow.postMessage(data, `nui://${this.RESOURCE_NAME}`);
                        return;
                    }
                }

                this.onMessage(data);
            });


            this.NUICallback('nui_ready');
        }
    
        async NUICallback(name, data = {}, asJSON = false) {
            const res = await fetch(`https://${this.RESOURCE_NAME}/${name}`, { method: 'POST', headers: { 'Accept' : 'application/json', 'Content-Type': 'application/json' }, body: JSON.stringify(data) });

            if(asJSON) { return res.json(); } else { return res.text(); }
        }
    
        createFrame(name, url, visible = true) {
            const container = document.createElement('div');
            const iframe = document.createElement('iframe');
            const jFrame = $(iframe);

            jFrame.on('load', function() {
                $(this).contents().find('body').append('<script src="https://cdn.jsdelivr.net/npm/iframe-resizer@4.3.1/js/iframeResizer.contentWindow.min.js"></script>');
            });

            container.setAttribute('name', name);
            container.setAttribute('id', `fiveux-${name}`);
            container.classList.add('fiveux-frame');
            container.appendChild(iframe);

            iframe.src = url;
            iframe.setAttribute('name', `iframe-${name}`);
            iframe.setAttribute('frameBorder', 0);
            iframe.style.width = `${window.screen.width}px`;
            iframe.style.height = `${window.screen.height}px`;
            iframe.style.overflow = 'hidden';

            document.querySelector('#fiveux-frames').appendChild(container);

            const rframe = iFrameResize({
                log: false,
                autoResize: true,
                checkOrigin: false,
                heightCalculationMethod: 'bodyOffset',
                minHeight: window.screen.height,
                minWidth: window.screen.width,
                resizeFrom: 'parent',
                widthCalculationMethod: 'bodyOffset'
            }, iframe);

            this.frames[name] = { frame: $(container), iframe: iframe, rframe: rframe, jFrame: jFrame };
            this.frames[name].frame.css('pointerEvents', 'none');

            if(!visible) { this.hideFrame(name); }

            this.frames[name].iframe.contentWindow.addEventListener('DOMContentLoaded', () => {
                this.NUICallback('frame_load', {name});
            }, true);

            return this.frames[name];
        }
    
        destroyFrame(name) {
            this.frames[name].jFrame.remove();
            this.frames[name].frame.remove();

            delete this.frames[name];
        }
    
        showFrame(name) { this.frames[name].frame.css('display', 'block'); }
        hideFrame(name) { this.frames[name].frame.css('display', 'none'); }
    
        focusFrame(name) {
            for(const k in this.frames) {
                if(k === name) {
                    this.frames[k].frame.css('pointerEvents', 'all');
                } else {
                    this.frames[k].frame.css('pointerEvents', 'none');
                }
            }

            this.frames[name].iframe.contentWindow.focus();
        }
    
        onMessage(msg) {
            if(msg.target && this.frames[msg.target]) {
                this.frames[msg.target].iframe.contentWindow.postMessage(msg.data);
            } else {
                switch(msg.action) {
                    case 'create_frame' : { this.createFrame(msg.name, msg.url, msg.visible); break; }
                    case 'destroy_frame' : { this.destroyFrame(msg.name); break; }
                    case 'focus_frame' : { this.focusFrame(msg.name); break; }
                    case 'show_frame' : { this.showFrame(msg.name); break; }
                    case 'hide_frame' : { this.hideFrame(msg.name); break; }
                    default: break;
                }
            }
        }
    }
    
    window.FRAMEROOT = window.FRAMEROOT || new iFRAMEROOT();
})();