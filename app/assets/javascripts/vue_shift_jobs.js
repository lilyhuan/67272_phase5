////////////////////////////////////////////////
//// Setting up a general ajax method to handle
//// transfer of data between client and server
////////////////////////////////////////////////
function run_ajax(method, data, link, callback=function(res){shift_job.get_shift_job()}){
    $.ajax({
      method: method,
      data: data,
      url: link,
      success: function(res) {
        shift_job.errors = {};
        callback(res);
      },
      error: function(res) {
        console.log("error");
        shift_job.errors = res.responseJSON;
      }
    })
  }
  
  //////////////////////////////////////////////
  //// A component to create a dosage list item
  //////////////////////////////////////////////
  Vue.component('dosage-row', {
    // Start with the template: two methods to consider...
    // (1) defining where to look for the HTML template in the index view
    // template: '#dosage-row',
    // _or_ (2) define it directly in the js file as such:
    template: `
      <li>
        <a v-on:click="remove_record(dosage)" class="remove">x&nbsp;&nbsp;</a>
        {{ dosage.medicine_name }}:&nbsp;&nbsp;
        {{ dosage.units_given }}&nbsp;units
      </li>
    `,
  
    // Passed elements to the component from the Vue instance
    props: {
      dosage: Object
    },
  
    // Behaviors associated with this component
    methods: {
      remove_record: function(dosage){
        run_ajax('DELETE', {dosage: dosage}, '/shift_job/'.concat(dosage['id'], '.json'));       
      }
    }
  });
  
  /////////////////////////////////////////
  //// A component for adding a new dosage
  /////////////////////////////////////////
  var new_form = Vue.component('new-dosage-form', {
    template: '#dosage-form-template',
  
    mounted() {
      // need to reconnect the materialize select javascript 
      $('#dosage_medicine_id').material_select()
    },
  
    data: function () {
      return {
          medicine_id: 0,
          visit_id: 0,
          units_given: 0, 
          discount: 0,
          errors: {}
      }
    },
  
    methods: {
      submitForm: function (x) {
        new_post = {
          medicine_id: this.medicine_id,
          visit_id: this.visit_id,
          units_given: this.units_given,
          discount: this.discount
        }
        run_ajax('POST', {dosage: new_post}, '/shift_job.json')
        this.switch_modal()
      }
    },
  })
  
  
  //////////////////////////////////////////
  ////***  The Vue instance itself  ***////
  /////////////////////////////////////////
  var shift_job = new Vue({
  
    el: '#dosage_handling',
  
    data: {
      visit_id: 0,
      shift_job: [],
      modal_open: false,
      errors: {}
    },
  
    created() {
      // read the visit_id from the page when instance created
      this.visit_id = $('#visit_id').val();
    },
  
    methods: {
      switch_modal: function(event){
        this.modal_open = !(this.modal_open);
      },
  
      get_shift_job: function(){
        run_ajax('GET', {}, '/visits/'.concat(this.visit_id, '/shift_job.json'), function(res){shift_job.shift_job = res});
      }
    },
  
    mounted: function(){
      this.get_shift_job();
    }
  });
  