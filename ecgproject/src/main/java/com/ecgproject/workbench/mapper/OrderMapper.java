package com.ecgproject.workbench.mapper;

import com.ecgproject.workbench.domain.Department;
import com.ecgproject.workbench.domain.Order;

import java.util.List;
import java.util.Map;

public interface OrderMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table order
     *
     * @mbggenerated Sat Apr 23 21:04:16 CST 2022
     */
    int deleteByPrimaryKey(String orderId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table order
     *
     * @mbggenerated Sat Apr 23 21:04:16 CST 2022
     */
    int insert(Order record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table order
     *
     * @mbggenerated Sat Apr 23 21:04:16 CST 2022
     */
    int insertSelective(Order record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table order
     *
     * @mbggenerated Sat Apr 23 21:04:16 CST 2022
     */
    Order selectByPrimaryKey(String orderId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table order
     *
     * @mbggenerated Sat Apr 23 21:04:16 CST 2022
     */
    int updateByPrimaryKeySelective(Order record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table order
     *
     * @mbggenerated Sat Apr 23 21:04:16 CST 2022
     */
    int updateByPrimaryKey(Order record);

    /**
     * 根据条件查询预约
     */
    List<Order> selectOrderByConditionForPage(Map<String,Object> map);

    /**
     * 根据条件查询预约总条数
     */
    int selectCountOfOrderByCondition(Map<String,Object> map);
}