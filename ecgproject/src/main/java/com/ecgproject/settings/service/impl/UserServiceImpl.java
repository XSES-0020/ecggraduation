package com.ecgproject.settings.service.impl;

import com.ecgproject.settings.domain.User;
import com.ecgproject.settings.mapper.UserMapper;
import com.ecgproject.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("userService")
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public User queryUserByLoginActAndPwd(Map<String, Object> map) {
        return userMapper.selectUserByLoginActAndPwd(map);
    }

    @Override
    public List<User> queryAllUsers() {
        return userMapper.selectAllUsers();
    }

    @Override
    public int saveCreateUser(User user) {
        return userMapper.insertUser(user);
    }
}
