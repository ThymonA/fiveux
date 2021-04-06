(($) => {
    class FiveUX {
        constructor() {
            this.frames         = {};
            this.RESOURCE_NAME  = typeof GetParentResourceName !== 'undefined' ? GetParentResourceName() : 'fiveux';
            this.ENVIRONMENT    = 'client';
            this.__NAME__       = 'global';
            this.__PRIMARY__    = 'glboal';
            this.container  = $('#fiveux-frames');

            window.addEventListener('message', this.messageHandler);

            this.nuiCallback('nui_ready');
        }

        async nuiCallback(name, data = {}, asJson = false) {
            const result = await fetch(`https://${this.RESOURCE_NAME}/${name}`, { method: 'POST', headers: { 'Accept' : 'application/json', 'Content-Type': 'application/json' }, body: JSON.stringify(data) });
        
            if (asJson) {
                return result.json();
            } else {
                return result.text();
            }
        }

        createNewContainer = (name) => {
            const newContainer = $('div');

            newContainer.attr('id', `frame-${name}`);
            newContainer.attr('frameBorder', 0);
            newContainer.attr('name', `frame-${name}`);
            newContainer.css('width', `${window.screen.width}px`);
            newContainer.css('height', `${window.screen.height}px`);
            newContainer.css('overflow', 'hidden');
            
            this.container.append(newContainer);

            return newContainer;
        }

        createFrame = (name, url) => {
            const frameName = `frame-${name}`;
            const newContainer = this.createNewContainer(name);
            const newFrame = new pym.Parent(frameName, url, {
                id: frameName,
                name: frameName,
                allowfullscreen: true,
                title: 'FiveUX'
            });

            this.frames[name] = {
                name: frameName,
                container: newContainer,
                pym: newFrame,
                iframe: newFrame.iframe
            }

            newFrame.iframe.style.width = `${window.screen.width}px`;
            newFrame.iframe.style.height = `${window.screen.height}px`;
            newFrame.iframe.style.overflow = 'hidden';

            this.nuiCallback('nui_created', { name: name });
        }

        destroyFrame = (name) => { }
        showFrame = (name) => { }
        hideFrame = (name) => { }
        focusFrame = (name) => { }

        messageHandler = (messageEvent) => {
            const data = messageEvent.data || messageEvent.detail || null;

            if (data == null) { return; }

            const name = data.source || 'unknown';

            if (typeof this.frames == 'undefined' || this.frames === undefined || this.frames == null || typeof this.frames[name] == 'undefined' || this.frames[name] === undefined || this.frames[name] == null) {
                switch(data.action) {
                    case 'create_frame' : { this.createFrame(data.name, data.url); break; }
                    case 'destroy_frame' : { this.destroyFrame(data.name); break; }
                    case 'focus_frame' : { this.focusFrame(data.name); break; }
                    case 'show_frame' : { this.showFrame(data.name); break; }
                    case 'hide_frame' : { this.hideFrame(data.name); break; }
                    default: break;
                }
                return;
            }

            const frame = this.frames[name] || null;

            if (frame == null) { return; }

            frame.pym.sendMessage('message', JSON.stringify(data));
        }
    }

    window.FiveUX = window.FiveUX || new FiveUX();
})(($ || jQuery));