package com.ecgproject.settings.service;

import com.ecgproject.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserService {
    User queryUserByLoginActAndPwd(Map<String,Object> map);

    List<User> queryAllUsers();

    int saveCreateUser(User user);
}

