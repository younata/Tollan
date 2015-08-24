require 'lockitron'

module LockHelper
  def lock_user(auth_token)
    Lockitron::User.new auth_token
  end

  def lock_json(lock)
    {"uuid" => lock.uuid, "locked" => lock.locked?, "name" => lock.name}
  end

  def update_lock(lock, to_lock)
    to_lock_bool = to_bool(to_lock)
    if to_lock_bool
      lock.lock
    else
      lock.unlock
    end
    {"uuid" => lock.uuid, "locked" => to_lock_bool, "name" => lock.name}
  end

  private

  def to_bool(obj)
    return true if obj == true || obj =~ (/(true|t|yes|y|1)$/i)
    return false if obj == false || obj =~ (/(false|f|no|n|0)$/i)
    return true
  end
end
