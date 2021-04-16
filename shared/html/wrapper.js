(() => {
    class FXWrapper {
        constructor() {
            this.resName = window.GetParentResourceName ? GetParentResourceName() : 'fiveux';

            window.addEventListener('keydown', e => this.onKeyDown(e));
            window.addEventListener('keyup', e => this.onKeyUp(e));
            window.addEventListener('mouseup', e => this.onMouseUp(e));
            window.addEventListener('mousedown', e => this.onMouseDown(e));
            window.addEventListener('mousewheel', e => this.onMouseWheel(e));
            window.addEventListener('contextmenu', e => this.onContextMenu(e));

            window.NUICallback = (name, data = {}, asJSON = false) => this.NUICallback(name, data, asJSON);
        }

        postFrameMessage(msg) {

            if (window.__FXROOT__)
                window.__FXROOT__.postFrameMessage('__root__', msg);
            else
                window.parent.postMessage({ ...msg, __fxinternal: true }, '*');
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

        onKeyDown(e) { this.postFrameMessage({ action: 'key:down', args: [e.keyCode] }); }
        onKeyUp(e) { this.postFrameMessage({ action: 'key:up', args: [e.keyCode] }); }
        onMouseDown(e) { this.postFrameMessage({ action: 'mouse:down', args: [e.button] }); }
        onMouseUp(e) { this.postFrameMessage({ action: 'mouse:up', args: [e.button] }); }
        onMouseMove(e) { this.postFrameMessage({ action: 'mouse:move', args: [e.screenX, e.screenY] }); }
        onMouseWheel(e) { this.postFrameMessage({ action: 'mouse:wheel', args: [(e.wheelDelta > 0 ? 1 : -1)] }); }
        onContextMenu(e) { this.postFrameMessage({ action: 'context', args: [] }); }
    }

    window.__FXWRAPPER__ = window.__FXWRAPPER__ || new FXWrapper();
})()