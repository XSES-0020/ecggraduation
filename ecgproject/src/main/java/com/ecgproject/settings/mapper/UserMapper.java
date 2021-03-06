package com.ecgproject.settings.mapper;

import com.ecgproject.settings.domain.Staff;
import com.ecgproject.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table user
     *
     * @mbggenerated Mon May 02 18:38:03 CST 2022
     */
    int deleteByPrimaryKey(String userId);


    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table user
     *
     * @mbggenerated Mon May 02 18:38:03 CST 2022
     */
    int insertSelective(User record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table user
     *
     * @mbggenerated Mon May 02 18:38:03 CST 2022
     */
    User selectByPrimaryKey(String userId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table user
     *
     * @mbggenerated Mon May 02 18:38:03 CST 2022
     */
    int updateByPrimaryKeySelective(User record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table user
     *
     * @mbggenerated Mon May 02 18:38:03 CST 2022
     */
    int updateByPrimaryKey(User record);

    /**
     * 根据账号密码查询用户
     * @param map
     * @return
     */
    User selectUserByLoginActAndPwd(Map<String,Object> map);

    /**
     * 查询所有用户
     * @return
     */
    List<User> selectAllUsers();

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table user
     *
     * @mbggenerated Sun Apr 03 22:46:07 CST 2022
     */
    int insertUser(User user);

    /**
     * 根据id改密码
     * @param map
     * @return
     */
    int updateUserPwdById(Map<String,Object> map);

    /**
     * 根据条件分页查询
     */
    List<User> selectUserByConditionForPage(Map<String,Object> map);

    /**
     * 根据条件查询员工的总条数
     * @param map
     * @return
     */
    int selectCountOfUserByCondition(Map<String,Object> map);

    /**
     * 只能改电话/备注
     * @param map
     * @return
     */
    int updateUserById(Map<String,Object> map);
}