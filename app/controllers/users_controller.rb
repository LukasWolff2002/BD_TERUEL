class UsersController < ApplicationController
    def index
      @users = User.order(:cargo)
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      
      if @user.save
        redirect_to users_path, notice: 'Usuario creado exitosamente.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to users_path, notice: 'Usuario actualizado exitosamente.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy
      redirect_to users_path, notice: 'Usuario eliminado exitosamente.', status: :see_other
    end

    private

    def user_params
      params.require(:user).permit(:nombre, :apellido, :rut, :cargo, :contrato)
    end
  end

  