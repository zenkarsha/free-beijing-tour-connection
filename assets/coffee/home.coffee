#==========================================
# Component
#==========================================
Vue.component 'dot-item',
  template: """
    <span :class="['dot-text-wrapper', selected ? 'selected' : '']" v-on:click="toggle_select">
      <span>{{ config.text }}</span>
    </span>
  """
  props: [ 'config', 'dot_index' ]
  data: ->
    {
      selected: false
    }
  methods:
    toggle_select: ->
      if @selected is true
        @selected = false
        @remove @dot_index
      else
        @selected = true
        @add @dot_index

    add: (dot_index) ->
      @$emit 'add_dot', dot_index

    remove: (dot_index) ->
      @$emit 'remove_dot', dot_index


Vue.component 'download-button',
  template: """
    <button class="button" type="button" v-on:click="handle_html2canvas" v-bind:disabled="processing">下載本頁截圖</button>
  """
  data: ->
    {
      processing: false
    }
  methods:
    handle_html2canvas: ->
      @processing = true
      NProgress.start()
      _self = @
      $('#output-dots').html($('#dots').clone())
      setTimeout(( ->
        capture_element = '#output-container'
        if isMobile() then capture_element = '#container'
        html2canvas(document.querySelector(capture_element), { scale: 1, logging: false }).then (canvas) ->
          base64 = canvas.toDataURL 'image/png'
          xx isMobile()
          if isMobile()
            _self.upload_imgur base64, (result) ->
              if result.data.link
                NProgress.done()
                image_url = 'https://i.imgur.com/' + result.data.id + '.png'
                swal
                  text: '請在圖片上長按以下載圖片'
                  imageUrl: image_url
                  animation: false
                  confirmButtonText: '關閉'
                  confirmButtonClass: 'button'
                  buttonsStyling: false
              else
                NProgress.done()
                alert '糟糕！出錯了！請稍後再試！'
            , (error) ->
              xx error
          else
            NProgress.done()
            forceDownload base64, 'ticket.png'
          _self.processing = false
      ).bind(@), 1000)

    upload_imgur: (base64, callback, error_callback) ->
      _self = @
      $.ajax
        url: 'https://api.imgur.com/3/image'
        type: 'post'
        headers: Authorization: 'Client-ID 36f2c6c4618678a'
        data:
          image: base64.split(",")[1]
          type: 'base64'
          description: 'Image generate by: https://free-beijing-tour-connection.unlink.men'
        dataType: 'json'
        success: (result) ->
          if result.success
            callback result
          else
            alert '糟糕！出錯了！請稍後再試！'
        error: (error) ->
          error_callback error


#==========================================
# App
#==========================================
app = new Vue(
  delimiters: ['{!', '!}']
  el: '#app'
  data:
    dots: [
      { text: '曾經稱呼習近平為習包子' }
      { text: '曾經玩過還願' }
      { text: '認為中國和台灣是兩個不同的國家' }
      { text: '會唱島嶼天光' }
      { text: '認為民主政治優於共產主義' }
      { text: '寫過同人小說並發表' }
      { text: '曾經發表抨擊中國政治制度或形象的言論' }
      { text: '認為周子瑜揮華國國旗沒有錯' }
      { text: '喜歡看小熊維尼的動畫' }
      { text: '堅決拒絕購買華為和小米產品' }
      { text: '認為九二共識的一個中國是中華民國' }
      { text: '認為集會遊行是人民基本自由' }
      { text: '認為台獨是台灣唯一的出路' }
      { text: '不承認九二共識' }
      { text: '曾經買過閃靈樂團的演唱會門票和周邊商品' }
      { text: '不看中天、中視、旺中媒體' }
      { text: '認為兩岸一家親這句話令人作噁' }
      { text: '我是同性戀/女權主義/動保/環保人士' }
      { text: '認為六四事件是一場大屠殺' }
      { text: '喜歡穿黑色衣服、撐黃色雨傘、隨身攜帶瓶裝水' }
      { text: '覺得達賴喇嘛可愛愛❤️' }
      { text: '認同鄭南榕追求百分之百言論自由的作為' }
      { text: '認為人民有宗教信仰之自由' }
      { text: '認為應當裁撤陸委會，並將職權轉移給外交部' }
      { text: '支持或認同香港雨傘運動、反送中運動' }
    ]
    selected_dots: []
    selected_rows: {
      # horizontal
      'row_0_4': false
      'row_5_9': false
      'row_10_14': false
      'row_15_19': false
      'row_20_24': false

      # vertical
      'row_0_20': false
      'row_1_21': false
      'row_2_22': false
      'row_3_23': false
      'row_4_24': false

      # slash
      'row_0_24': false
      'row_4_20': false
    }
    rows_counter: 0

  methods:
    handle_add_dot: (dot_index) ->
      @selected_dots.push dot_index

    handle_remove_dot: (dot_index) ->
      @selected_dots = @selected_dots.filter((value, index) ->
        value isnt dot_index
      )

    row_check: (array, row_name) ->
      total = @selected_dots.length
      counter = 0
      _self = @
      @selected_dots.forEach (item, index) ->
        if in_array(item, array) then counter++
        if index is (total - 1)
          if counter is 5
            _self.selected_rows[row_name] = true
            _self.rows_counter += 1
          else
            _self.selected_rows[row_name] = false

  watch:
    selected_dots: (value) ->
      @rows_counter = 0

      # horizontal
      @row_check([0,1,2,3,4], 'row_0_4')
      @row_check([5,6,7,8,9], 'row_5_9')
      @row_check([10,11,12,13,14], 'row_10_14')
      @row_check([15,16,17,18,19], 'row_15_19')
      @row_check([20,21,22,23,24], 'row_20_24')

      # vertical
      @row_check([0,5,10,15,20], 'row_0_20')
      @row_check([1,6,11,16,21], 'row_1_21')
      @row_check([2,7,12,17,22], 'row_2_22')
      @row_check([3,8,13,18,23], 'row_3_23')
      @row_check([4,9,14,19,24], 'row_4_24')

      # slash
      @row_check([0,6,12,18,24], 'row_0_24')
      @row_check([4,8,12,16,20], 'row_4_20')
)
