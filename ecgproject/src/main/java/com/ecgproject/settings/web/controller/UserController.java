package com.ecgproject.settings.web.controller;

import com.ecgproject.commons.constants.Constants;
import com.ecgproject.commons.domain.ReturnObject;
import com.ecgproject.settings.domain.Staff;
import com.ecgproject.settings.domain.User;
import com.ecgproject.settings.service.StaffService;
import com.ecgproject.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import sun.security.krb5.internal.crypto.HmacSha1Aes128CksumType;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private StaffService staffService;

    /**
     * url要和当前controller访问的页面资源目录保持一致，好找
     * controller习惯在后面带.do（搞不懂）
     * @return
     */
    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin()
    {
        //跳转到登陆页面
        return "settings/qx/user/login";
    }

    @RequestMapping("/settings/qx/user/toRegister.do")
    public String toRegister(){
        //跳转到注册页面
        /* //调试
        System.out.println("跳转至登录");*/
        return "settings/qx/user/register";
    }

    @RequestMapping("/settings/qx/user/toForget.do")
    public String toForget(){
        //跳转提示页面
        return "settings/qx/user/forget";
    }

    @RequestMapping("/settings/qx/user/updatePwd.do")
    public @ResponseBody Object updatePwd(String userId,String userPassword){
        Map<String,Object> map = new HashMap<>();
        map.put("userId",userId);
        map.put("userPassword",userPassword);

        ReturnObject returnObject = new ReturnObject();

        try{
            int ret = userService.updateUserPwdById(map);
            if(ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙碌，请稍后重试……");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙碌，请稍后重试……");
        }

        return returnObject;

    }

    @RequestMapping("/settings/qx/user/login.do")
    public @ResponseBody Object login(String loginAct, String loginPwd, HttpServletRequest request, HttpSession session){
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        //调用service方法，查询用户
        User user = userService.queryUserByLoginActAndPwd(map);
        //根据查询结果生成响应信息
        Map<String,Object> ret = new HashMap<>();

        ReturnObject returnObject = new ReturnObject();
        if(user==null){
            //登陆失败 用户名/密码错误
            ret.put("code","0");
            ret.put("message","用户名或密码错误");
            //returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            //returnObject.setMessage("用户名或密码错误");
        }else{//登陆成功
            /*获取ip地址
            request.getRemoteAddr();
            */
            //returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            ret.put("code","1");
            ret.put("role",user.getUserType());
            //user保存到session
            session.setAttribute(Constants.SESSION_USER,user);
        }
        return ret;
    }

    @RequestMapping("/settings/qx/user/register.do")
    public @ResponseBody Object register(String userId,String userPassword){
        /*//调试
        System.out.println(userId);*/

        ReturnObject returnObject = new ReturnObject();
        try{
            //先调staff的service查一下有没有注册过
            Staff staff = staffService.queryStaffByRegisterAct(userId);
            if(staff!=null){
                int status = staff.getStaffStatus();
                if(status==1){
                    //有该员工且已注册
                    returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                    returnObject.setMessage("该工号已被注册");
                }else if(status==0){
                    //有该员工且可以注册
                    //封装参数
                    String name = staff.getStaffName();
                    User user = new User();
                    user.setUserId(userId);
                    user.setUserPassword(userPassword);
                    user.setUserCreatetime(new Date());
                    user.setUserType(0);
                    user.setUserName(name);

                    //调用service层注册
                    try{
                        int ret1 = userService.saveCreateUser(user);
                        int ret2 = staffService.updateStatusById(userId);
                        if(ret1>0&&ret2>0){
                            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                        }else{
                            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                            returnObject.setMessage("系统忙碌，请稍后重试……");
                        }
                    }catch (Exception e){
                        e.printStackTrace();
                        returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                        returnObject.setMessage("系统忙碌，请稍后重试……");
                    }
                }
            } else{
                //没有这号人
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("该工号不属于医院员工");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙碌，请稍后重试……");
        }

        return returnObject;
    }

    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpServletRequest response,HttpSession session){
        //清空cookie

        //销毁session
        session.invalidate();

        //跳转首页，这里用重定向（借助springmvc框架）
        return "redirect:/";
    }
}
