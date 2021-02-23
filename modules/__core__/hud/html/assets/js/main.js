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
        },
        UPDATE_STATS({ updates }) {
            updates = typeof updates == 'object' ? updates : {};

            const health = typeof updates.health == 'undefined' ? this.health : (typeof updates.health == 'number' ? updates.health : Number(updates.health));
            const armor = typeof updates.armor == 'undefined' ? this.armor : (typeof updates.armor == 'number' ? updates.armor : Number(updates.armor));
            const stamina = typeof updates.stamina == 'undefined' ? this.stamina : (typeof updates.stamina == 'number' ? updates.stamina : Number(updates.stamina));
            const thirst = typeof updates.thirst == 'undefined' ? this.thirst : (typeof updates.thirst == 'number' ? updates.thirst : Number(updates.thirst));
            const hunger = typeof updates.hunger == 'undefined' ? this.hunger : (typeof updates.hunger == 'number' ? updates.hunger : Number(updates.hunger));
            const stressed = typeof updates.stressed == 'undefined' ? this.stressed : (typeof updates.stressed == 'number' ? updates.stressed : Number(updates.stressed));
        
            this.health = health <= 0 ? 0 : (health >= 100 ? 100 : health)
            this.armor = armor <= 0 ? 0 : (armor >= 100 ? 100 : armor)
            this.stamina = stamina <= 0 ? 0 : (stamina >= 100 ? 100 : stamina)
            this.thirst = thirst <= 0 ? 0 : (thirst >= 100 ? 100 : thirst)
            this.hunger = hunger <= 0 ? 0 : (hunger >= 100 ? 100 : hunger)
            this.stressed = stressed <= 0 ? 0 : (stressed >= 100 ? 100 : stressed)
        }
    }
}

const FIVEUX_HUD_VUE = new Vue({
    el: '#fiveux-hud',
    render: hud => hud(FIVEUX_HUD)
});