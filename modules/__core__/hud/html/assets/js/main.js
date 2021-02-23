window.FIVEUX_HUD = {
    template: '#fiveux-hud-template',
    name: 'FIVEUX_HUD',
    data() {
        return {
            name: 'FiveUX Framework',
            job_label: 'Unemployed',
            grade_label: 'Unemployed',
            job2_label: 'Unemployed',
            grade2_label: 'Unemployed',
            cash: 0,
            crime: 0,
            health: 100,
            armor: 0,
            stamina: 100,
            thirst: 100,
            hunger: 100,
            stressed: 0,
            listener: (e) => {},
            RESOURCE_NAME: typeof GetParentResourceName !== 'undefined' ? GetParentResourceName() : 'fiveux',
            locale: 'en-EN'
        }
    },
    mounted() {
        this.listener = (e) => {
            const data = e.data || e.detail || null;

            if (!data || !data.action) { return; }

            if (this[data.action]) {
                this[data.action](data);
            }
        };

        window.addEventListener('message', this.listener);

        this.POST('mounted', {})
    },
    watch: {
        name() {},
        job_label() {},
        grade_label() {},
        job2_label() {},
        grade2_label() {},
        cash() {},
        crime() {},
        health() {},
        armor() {},
        stamina() {},
        thirst() {},
        hunger() {},
        stressed() {}
    },
    methods: {
        POST: function(name, data = {}) {
            const request = new XMLHttpRequest();
            const url = `https://${this.RESOURCE_NAME}/hud:${name}`;

            data.module = 'hud';

            request.open('POST', url, true);
            request.setRequestHeader('Content-Type', 'application/json; charset=UTF-8');
            request.send(JSON.stringify(data));
        },
        INIT({ job, job2, locale, name, cash, crime }) {
            this.locale = locale || 'en-EN';
            this.name = name || 'FiveUX Framework';
            this.job_label = job.name || 'Unknown';
            this.grade_label = job.grade || 'Unknown';
            this.job2_label = job2.name || 'Unknown';
            this.grade2_label = job2.grade || 'Unknown';
            this.cash = typeof cash == 'number' ? cash : Number(cash);
            this.crime = typeof crime == 'number' ? crime : Number(crime);
        },
        format_number(number) {
            number = typeof number == 'number' ? number : Number(number);

            return number.toLocaleString(this.locale, { minimumFractionDigits: 0 });
        }
    }
}

const FIVEUX_HUD_VUE = new Vue({
    el: '#fiveux-hud',
    render: hud => hud(FIVEUX_HUD)
});