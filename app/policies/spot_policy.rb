class SpotPolicy < ApplicationPolicy
  attr_reader :user, :spot

  def initialize(user, spot)
    @user = user
    @spot = spot
  end

  def show?
    spot.user == user
  end

  def create?
    spot.user == user
  end

  def update?
    spot.user == user
  end

  def destroy?
    spot.user == user
  end

  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end
end
