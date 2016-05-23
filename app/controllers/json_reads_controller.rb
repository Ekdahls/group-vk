class JsonReadsController < ApplicationController
	require 'json'
	require 'rest_client'
	$quiz_arr = Array.new()
	$i = 0


	QUESTION_API_BASE_URL 	= "http://adminplatform.herokuapp.com/api"
	SCRIPT_BASE_URL 		= "http://mega.vk.se/dev/og-stuff.php?url="

	def index
		get_quest
		$randno = rand(1...5)
	end
	def startpage
		$article_arr = Array.new()
		$result_arr = Array.new()
		
		$quiz_arr.clear
		#$randno.clear
		$i = 0
	end

	def get_quest	
		get_data
		
		$finish = false
		unless $finish == true
			$randId = rand(0...(@data.length-1))
			while $quiz_arr.include?(@data[$randId]['id']) 
				$randId = rand(0...(@data.length-1))
			end
			$quiz_arr.push(@data[$randId]['id'])
			$i += 1

			if $i == 7
				$finish = true	
			end

			@quest = @data[$randId]['question_name']
			@c_answer = @data[$randId]['c_answer']
			@alt1 = @data[$randId]['alt1']
			@alt2 = @data[$randId]['alt2']
			@alt3 = @data[$randId]['alt3']
			@imgurl = @data[$randId]['imgurl']
			@url = @data[$randId]['news_url']
			@cat = @data[$randId]['category_id']
			@hex = @data[$randId]['category_hex_code']
			get_descriptions(@url)

			@image = @desc_data['image']
	 	end
	end						

	def answer
		get_data

		@summary = @data[$randId]['news_summary']
		@c_answer = @data[$randId]['c_answer']
		@alt1 = @data[$randId]['alt1']
		@alt2 = @data[$randId]['alt2']
		@alt3 = @data[$randId]['alt3']
		@cat = @data[$randId]['category_id']
		@ans = params[:param1]
		@id = params[:param2]
		@url = @data[$randId]['news_url']
		@hex = @data[$randId]['category_hex_code']

		get_descriptions(@url)

		@title = @desc_data['title']
		@summary = @desc_data['desc']

		tagstring = @data[$randId]['tag']
		unless tagstring.nil? || tagstring.empty?
			@tags = tagstring.split(",")
			@taglength = @tags.length
		end
	end

	def get_data
		uri ="#{QUESTION_API_BASE_URL}/questions.json" 
		rest_resource = RestClient::Resource.new(uri)
		data = rest_resource.get
		@data= JSON.parse(data, :symbolize_name => true)

	end


	def get_descriptions(articleurl)
		uri ="#{SCRIPT_BASE_URL}" + articleurl
		rest_resource = RestClient::Resource.new(uri)
		desc_data = rest_resource.get
		@desc_data = JSON.parse(desc_data, :symbolize_name => true)
	end

	def result

		@result = $result_arr.join("")

	end

end