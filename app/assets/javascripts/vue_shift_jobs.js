// ////////////////////////////////////////////////
// //// Setting up a general ajax method to handle
// //// transfer of data between client and server
// ////////////////////////////////////////////////
// function run_ajax(method, data, link, callback=function(res){shift_jobs.get_shift_jobs()}){
//     $.ajax({
//       method: method,
//       data: data,
//       url: link,
//       success: function(res) {
//         shift_jobs.errors = {};
//         callback(res);
//       },
//       error: function(res) {
//         console.log("error");
//         shift_jobs.errors = res.responseJSON;
//       }
//     })
//   }

//   //////////////////////////////////////////////
//   //// A component to create a dosage list item
//   //////////////////////////////////////////////
//   Vue.component('shift_job-row', {
//     // Start with the template: two methods to consider...
//     // (1) defining where to look for the HTML template in the index view
//     // template: '#shift_job-row',
//     // _or_ (2) define it directly in the js file as such:
//     template: `
//       <li>
//         <a v-on:click="remove_record(shift_job)" class="remove">x&nbsp;&nbsp;</a>
//         {{ shift_job.job.name }}:&nbsp;&nbsp;
//       </li>
//     `,

//     // Passed elements to the component from the Vue instance
//     props: {
//       shift_job: Object
//     },

//     // Behaviors associated with this component
//     methods: {
//       remove_record: function(shift_job){
//         run_ajax('DELETE', {shift_job: shift_job}, '/shift_job/'.concat(shift_job['id'], '.json'));       
//       }
//     }
//   });

//   /////////////////////////////////////////
//   //// A component for adding a new dosage
//   /////////////////////////////////////////
//   var new_form = Vue.component('new-shift_job-form', {
//     template: '#shift_job-form-template',

//     mounted() {
//       // need to reconnect the materialize select javascript 
//       $('#shift_job_job_id').material_select()
//     },

//     data: function () {
//       return {
//           job_id: 0,
//           shift_id: 0,
//           errors: {}
//       }
//     },

//     methods: {
//       submitForm: function (x) {
//         new_post = {
//           shift_id: this.shift_id,
//           job_id: this.job_id,
//         }
//         run_ajax('POST', {shift_job: new_post}, '/shift_jobs.json')
//         this.switch_modal()
//       }
//     },
//   })


//   //////////////////////////////////////////
//   ////***  The Vue instance itself  ***////
//   /////////////////////////////////////////
//   var shift_jobs = new Vue({

//     el: '#shift_job_handling',

//     data: {
//       shift_id: 0,
//       shift_jobs: [],
//       modal_open: false,
//       errors: {}
//     },

//     created() {
//       // read the shift_id from the page when instance created
//       this.shift_id = $('#shift_id').val();
//     },

//     methods: {
//       switch_modal: function(event){
//         this.modal_open = !(this.modal_open);
//       },

//       get_shift_jobs: function(){
//         run_ajax('GET', {}, '/shifts/'.concat(this.shift_id, '/shift_jobs.json'), function(res){shift_jobs.shift_jobs = res});
//       }
//     },

//     mounted: function(){
//       this.get_shift_jobs();
//     }
//   });
