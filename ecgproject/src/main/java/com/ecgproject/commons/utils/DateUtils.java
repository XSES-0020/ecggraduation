package com.ecgproject.commons.utils;

import org.springframework.format.annotation.DateTimeFormat;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 对data类型数据处理的工具类
 */
public class DateUtils {
    /**
     * 对指定的date对象进行格式化
     * @param date
     * @return
     */
    public static String formateDateTime(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String dateStr = sdf.format(date);
        return dateStr;
    }

    /**
     * 解析心电图时间的
     * @param str
     * @return
     */
    public static String formateForHl7(String str){
        String dateStr = str.substring(0,4)+"/"+str.substring(4,6)+"/"+str.substring(6,8)+" "+str.substring(8,10)+":"+str.substring(10,12)+":"+str.substring(12,14);
        return dateStr;
    }
}
