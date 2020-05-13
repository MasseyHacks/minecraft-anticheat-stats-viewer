<template>
  <div class="container mt-5">
    <h1>Global Cheat Data</h1>
    <p>Last updated: {{$moment.unix(stats['timestamp']).format('MMM D YYYY, h:mm:ss a Z')}} ({{$moment.unix(stats['timestamp']).fromNow()}})</p>
    <hr>
    <div class="row">
      <div v-for="timeslot in ['1', '5','10', '30']" class="col-6">
        <h3>Latest cheat incidents {{timeslot}} minute(s)</h3>
        <div v-if="stats['compilation'][timeslot].length > 0">
          <table class="table table-bordered">
            <thead>
            <tr>
              <td>
                Time
              </td>
              <td>
                Cheat
              </td>
              <td>
                Player
              </td>
            </tr>
            </thead>
            <tbody>
            <tr v-for="incident in reversedList(stats['compilation'][timeslot])">
              <td>
                {{$moment.unix(stats['incidents'][incident].timestamp).format('MMM D YYYY, h:mm:ss a Z')}} ({{$moment.unix(stats['incidents'][incident].timestamp).fromNow()}})
              </td>
              <td>
                {{stats['incidents'][incident].cheat}}
              </td>
              <td class="d-flex align-items-center">
                <nuxt-link :to="'/player/' + stats['incidents'][incident].player">{{stats['players'][stats['incidents'][incident].player].name}} &nbsp;
                  <img :src="'https://crafatar.com/avatars/' + playerUUID(stats['incidents'][incident].player)" style="height: 1em"></nuxt-link>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
        <div v-else>
          No Data.
        </div>
      </div>
    </div>

  </div>
</template>

<script>

export default {
  data() {
    return {
      "stats": {}
    }
  },
  methods: {
    playerUUID(incident){
      return incident.substring(incident.indexOf(':')+1)
    },
    reversedList(oldList){
      return [...oldList].reverse()
    },
    async fetchStats(){
      let stats = await this.$axios.get(process.env.STATS_URL + '/stats');
      this.stats = stats.data.data;

      window.setTimeout(this.fetchStats, process.env.STATS_UPDATE_FREQ);
    }
  },
  async asyncData(context) {
    let stats = await context.$axios.get(process.env.STATS_URL + '/stats');
    return {"stats": stats.data.data};
  },
  mounted() {
    window.setTimeout(this.fetchStats, process.env.STATS_UPDATE_FREQ);
  }
}
</script>

<style>
</style>
