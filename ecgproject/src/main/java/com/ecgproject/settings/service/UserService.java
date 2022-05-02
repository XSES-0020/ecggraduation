package com.ecgproject.settings.service;

import com.ecgproject.settings.domain.Staff;
import com.ecgproject.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserService {
    User queryUserByLoginActAndPwd(Map<String,Object> map);

    List<User> queryAllUsers();

    int saveCreateUser(User user);

    //更新密码
    int updateUserPwdById(Map<String,Object> map);

    //删用户
    int deleteUserById(String userId);

    //根据条件分页查
    List<User> queryUserByConditionForPage(Map<String,Object> map);

    //根据条件查总数
    int queryCountOfUserByCondition(Map<String,Object> map);

    //修改电话和备注
    int updateUserById(Map<String,Object> map);

    //找
    User queryUserById(String userId);
}

