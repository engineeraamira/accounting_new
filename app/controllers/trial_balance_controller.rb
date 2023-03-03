class TrialBalanceController < ApplicationController
  
    # GET /home
    # GET /home.json
    def index

        #@dd = Account.find(1).descendant_ids
        #puts @dd
        # Account.all.descendants.reject(&:has_children?).each do |sub|
        #     puts "jkjk"
        # end

        # @fff = Account.where(id: Account.pluck(:parent_account).compact.map { |e| e.split('/') }.flatten.uniq)
        # @fff.all.each do |kk|
        #     puts kk.id
        # end

        # @sum_credits = {}
        # @sum_debits = {}
        # @has_child = Account.where("id IN (SELECT parent_account FROM accounts)").all.ids
        # @has_no_child = Account.where.not(id: @has_child).all
        # @has_no_child.all.each do |kk|
        #     #@sums = kk.daily_transaction_details.pluck('SUM(debit)', 'SUM(credit)')
            
        #     #@sums = kk.daily_transaction_details.all.pluck(:debit, :credit).map(&:sum).sum
        #     @sums = kk.daily_transaction_details.sum(:debit)
        #     #puts @sums
        #     @sum_debits[kk.id] = @sums
        #     # @sum_credits[kk.id] = @sums[1]
        # end


        # puts @sum_credits 
        # puts @sum_debits

        
        #@desc_accounts = Account.order("account_number DESC").all

        # @accountsa = Account.arrange
        # @hhh =  Account.get_descendants(@accountsa)  #@tree
        # puts @hhh


        # #sum all trans for all accounts
        # @accounts = Account.order(:account_number).includes(:daily_transaction_details)

        # @sum_array = {}
        # @accounts.each do |account|
        #     @sum_array[account.id] = account.daily_transaction_details.pluck("sum(debit)", "sum(credit)")
        # end

        # @familiar_array = {}
        # @sum_array.each do |hh, index|
        #     index.each do |kk|
        #         @debit = (kk[0] == nil)? 0.00 : kk[0]
        #         @credit = (kk[1] == nil)? 0.00 : kk[1]
        #         @familiar_array[hh] = [@debit,@credit ]
        #     end
        # end

        # #sum_children_transactions
        # @accounts.each do |account|
        #     @childrenIds = account.descendant_ids
        #     @childrenIds.each do |child|
        #         @familiar_array[account.id][0] += @familiar_array[child][0]
        #         @familiar_array[account.id][1] += @familiar_array[child][1]
        #     end
        # end


        #puts @familiar_array

        respond_to do |format|
            format.html
            format.pdf do
                # Rails 6:
                # render template: "posts/show.html.erb",
                #        pdf: "Post ID: #{@post.id}"
        
                # Rails 7:
                @accounts = get_trial_balance_records
                render pdf: 'hello',
                       template: "trial_balance/index",
                       formats: [:pdf],
                       encoding: "utf8",
                       disposition: :inline
                       #layout: 'pdf'
            end 
        end


      
    end

    def get_datatable
        if (params[:currency_id].empty? && params[:search][:value].empty? && params[:account_id].empty? && params[:level].empty? && params[:from_date].empty? && params[:to_date].empty?)
            @accounts = Account.where(id: 0).all
        else
            @accounts = get_trial_balance_records(params[:currency_id], params[:search][:value], params[:account_id], params[:level], params[:main_accounts], params[:from_date], params[:to_date])
        end
        @results = {}
        @count_records = @accounts.count
        @results["draw"] = params[:draw].to_i
        @results["recordsTotal"] = @count_records
        @results["recordsFiltered"] = @count_records
        @Length = (params[:length].to_i < 0)? @count_records : params[:length].to_i 
        @start = params[:start].to_i

        @accounts = @accounts.limit(@Length).offset(@start )
        @results["data"] = @accounts.map do |account|
                                @debit = @familiar_array[account.id][0]
								@credit = @familiar_array[account.id][1]
								@difference = @debit - @credit
                                @balance_debit = (@difference > 0)?  @difference : 0
                                @balance_credit = (@difference < 0)?  @difference.abs : 0
                                @item = {"accountNumber" => account.account_number, "nameAr" => account.name_ar, "debit" => 0.00, "credit" => 0.00, "total_debit" => @debit, "total_credit" => @credit,"debit_balance" => @balance_debit, "credit_balance" => @balance_credit}
                                @item
                            end
        respond_to do |format|
          format.html
          format.json { render json: @results}
        end

    end

    def get_trial_balance_records(currency_id=nil, search=nil, account_id=nil, level=nil, main_accounts=nil, from_date=nil, to_date=nil)
        #sum all trans for all accounts
        @accounts = Account.order(:account_number).all
        #@accounts = Account.order(:account_number).includes(:daily_transaction_details).all.references(:daily_transaction_details)    
        if(currency_id && !(currency_id.empty?))
            @hash = Account.includes(:daily_transaction_details).where(daily_transaction_details: {currency_id: currency_id}).group('accounts.id').pluck('accounts.id, SUM(daily_transaction_details.debit)', 'SUM(daily_transaction_details.credit)')
        else
            @hash = Account.includes(:daily_transaction_details).group('accounts.id').pluck('accounts.id', Arel.sql('SUM(daily_transaction_details.debit * daily_transaction_details.currency_rate)'), Arel.sql('SUM(daily_transaction_details.credit * daily_transaction_details.currency_rate)'))
        end
        #puts "hhhhhhh"
        #puts @hash
        @familiar_array = {}
        @get_accounts_data = @accounts.pluck(:id, :parent_account, :ancestry)
        #sum_children_transactions
        @accounts.each do |account|
            if(account.ancestry == nil)
                @childrenIds = @get_accounts_data.find_all { |el| ( (el[0] == account.id) ||  ( (el[2] != nil) && ((el[2] == account.id.to_s) ||  el[2].start_with?(account.id.to_s + "/") ))) } # a.select will do the same
            else
                @childrenIds = @get_accounts_data.find_all { |el| (  (el[0] == account.id) || ( (el[2] != nil) && ((el[2] == account.id.to_s) ||  el[2].start_with?(account.ancestry.to_s + "/" + account.id.to_s )))) } # a.select will do the same
            end

            # puts account.name_ar
            # puts @childrenIds
            @familiar_array[account.id] = [0.00,0.00]

            @childrenIds.each do |child|
                @child_id = child[0]
                $total_trans = @hash.detect{ |(n, _, _)| ((n == @child_id)) }
                if $total_trans != nil
                    @familiar_array[account.id][0] += ($total_trans[1] == nil)? 0.00 : $total_trans[1]   
                    @familiar_array[account.id][1] += ($total_trans[2] == nil)? 0.00 : $total_trans[2] 
                end 
            end
            #puts @familiar_array
        end

        if(search != nil && !(search.empty?))
            #puts search
            @search_text = search
            @accounts = @accounts.where("name_ar LIKE ? OR name_en LIKE ? OR account_number LIKE ?", "%#{@search_text}%", "%#{@search_text}%" , "%#{@search_text}%")
        end

        if(account_id != nil && !(account_id.empty?))
            @accounts = @accounts.where(id: account_id)
        end

        if(level != nil && !(level.empty?))
            @accounts = @accounts.before_depth(level.to_i)
        end

        if(params[:main_accounts] != nil && params[:main_accounts] == "false")           #display last node in each branch
            @accounts = @accounts.includes(:accounts).where(accounts_count: 0)
        end

        return @accounts
    end


    def export_trial_balance
        @file_format = params[:file_format]
        @accounts = get_trial_balance_records(params[:currency_id], nil, params[:account_id], params[:level], params[:main_accounts], params[:from_date], params[:to_date])
        if @file_format == "pdf"
            render pdf: 'hello',
                            template: "trial_balance/index",
                            formats: [:pdf],
                            encoding: "utf8",
                            disposition: :inline
        else
            render xlsx: 'مبزان المراجعة',
                    template: "trial_balance/index",
                    formats: [:xlsx],
                    encoding: "utf8",
                    disposition: :inline

        end


        #render json: {"Success": true, result: @accounts}
    end

    def export_pdf
        @accounts = params[:accounts]
        render pdf: 'مبزان المراجعة',
                       template: "trial_balance/index",
                       formats: [:pdf],
                       encoding: "utf8",
                       disposition: :inline

    end

    def get_descendants(node)
        @sum_debits = node.daily_transaction_details.sum(:debit)
        return @sum_debits
    end

end