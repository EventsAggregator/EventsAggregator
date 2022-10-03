class LikeCommentsController < ApplicationController

    def create
        @like_comment = current_user.like_comments.new(like_c_params)
        if !@like_comment.save
            flash[:notice]= @like_comment.errors.full_messages.to_sentence
        end

        redirect_to @like_comment.comment  # dovrò mettere il redirect all evento a cui appartiene il commento
    
    end

    def destroy
        @like_comment= current_user.like_comments.find(params[:id]) #dovrò inserire un nuovo modo per passargli l id del commento
        comment = @like_comment.comment # dovrò mettere l evento al posto del commento
        @like_comment.destroy
        redirect_to comment
    end


    private

    def like_c_params
        params.require(:like_comment).permit(:comment_id)
    end

end