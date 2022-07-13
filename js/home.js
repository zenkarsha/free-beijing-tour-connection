var app;Vue.component("dot-item",{template:"<span :class=\"['dot-text-wrapper', selected ? 'selected' : '']\" v-on:click=\"toggle_select\">\n  <span>{{ config.text }}</span>\n</span>",props:["config","dot_index"],data:function(){return{selected:!1}},methods:{toggle_select:function(){return!0===this.selected?(this.selected=!1,this.remove(this.dot_index)):(this.selected=!0,this.add(this.dot_index))},add:function(t){return this.$emit("add_dot",t)},remove:function(t){return this.$emit("remove_dot",t)}}}),Vue.component("download-button",{template:'<button class="button" type="button" v-on:click="handle_html2canvas" v-bind:disabled="processing">下載本頁截圖</button>',data:function(){return{processing:!1}},methods:{handle_html2canvas:function(){var t;return this.processing=!0,NProgress.start(),t=this,$("#output-dots").html($("#dots").clone()),setTimeout(function(){var e;return e="#output-container",isMobile()&&(e="#container"),html2canvas(document.querySelector(e),{scale:1,logging:!1}).then(function(e){var o;return o=e.toDataURL("image/png"),xx(isMobile()),isMobile()?t.upload_imgur(o,function(t){var e;return t.data.link?(NProgress.done(),e="https://i.imgur.com/"+t.data.id+".png",swal({text:"請在圖片上長按以下載圖片",imageUrl:e,animation:!1,confirmButtonText:"關閉",confirmButtonClass:"button",buttonsStyling:!1})):(NProgress.done(),alert("糟糕！出錯了！請稍後再試！"))},function(t){return xx(t)}):(NProgress.done(),forceDownload(o,"ticket.png")),t.processing=!1})}.bind(this),1e3)},upload_imgur:function(t,e,o){return this,$.ajax({url:"https://api.imgur.com/3/image",type:"post",headers:{Authorization:"Client-ID 36f2c6c4618678a"},data:{image:t.split(",")[1],type:"base64",description:"Image generate by: https://free-beijing-tour-connection.unlink.men"},dataType:"json",success:function(t){return t.success?e(t):alert("糟糕！出錯了！請稍後再試！")},error:function(t){return o(t)}})}}}),app=new Vue({delimiters:["{!","!}"],el:"#app",data:{dots:[{text:"曾經稱呼習近平為習包子"},{text:"曾經玩過還願"},{text:"認為中國和台灣是兩個不同的國家"},{text:"會唱島嶼天光"},{text:"認為民主政治優於共產主義"},{text:"寫過同人小說並發表"},{text:"曾經發表抨擊中國政治制度或形象的言論"},{text:"認為周子瑜揮華國國旗沒有錯"},{text:"喜歡看小熊維尼的動畫"},{text:"堅決拒絕購買華為和小米產品"},{text:"認為九二共識的一個中國是中華民國"},{text:"認為集會遊行是人民基本自由"},{text:"認為台獨是台灣唯一的出路"},{text:"不承認九二共識"},{text:"曾經買過閃靈樂團的演唱會門票和周邊商品"},{text:"不看中天、中視、旺中媒體"},{text:"認為兩岸一家親這句話令人作噁"},{text:"我是同性戀/女權主義/動保/環保人士"},{text:"認為六四事件是一場大屠殺"},{text:"喜歡穿黑色衣服、撐黃色雨傘、隨身攜帶瓶裝水"},{text:"覺得達賴喇嘛可愛愛❤️"},{text:"認同鄭南榕追求百分之百言論自由的作為"},{text:"認為人民有宗教信仰之自由"},{text:"認為應當裁撤陸委會，並將職權轉移給外交部"},{text:"支持或認同香港雨傘運動、反送中運動"}],selected_dots:[],selected_rows:{row_0_4:!1,row_5_9:!1,row_10_14:!1,row_15_19:!1,row_20_24:!1,row_0_20:!1,row_1_21:!1,row_2_22:!1,row_3_23:!1,row_4_24:!1,row_0_24:!1,row_4_20:!1},rows_counter:0},methods:{handle_add_dot:function(t){return this.selected_dots.push(t)},handle_remove_dot:function(t){return this.selected_dots=this.selected_dots.filter(function(e,o){return e!==t})},row_check:function(t,e){var o,r,n;return n=this.selected_dots.length,r=0,o=this,this.selected_dots.forEach(function(s,i){if(in_array(s,t)&&r++,i===n-1)return 5===r?(o.selected_rows[e]=!0,o.rows_counter+=1):o.selected_rows[e]=!1})}},watch:{selected_dots:function(t){return this.rows_counter=0,this.row_check([0,1,2,3,4],"row_0_4"),this.row_check([5,6,7,8,9],"row_5_9"),this.row_check([10,11,12,13,14],"row_10_14"),this.row_check([15,16,17,18,19],"row_15_19"),this.row_check([20,21,22,23,24],"row_20_24"),this.row_check([0,5,10,15,20],"row_0_20"),this.row_check([1,6,11,16,21],"row_1_21"),this.row_check([2,7,12,17,22],"row_2_22"),this.row_check([3,8,13,18,23],"row_3_23"),this.row_check([4,9,14,19,24],"row_4_24"),this.row_check([0,6,12,18,24],"row_0_24"),this.row_check([4,8,12,16,20],"row_4_20")}}});