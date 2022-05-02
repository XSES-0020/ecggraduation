package com.ecgproject.workbench.web.controller;

import com.alibaba.druid.support.json.JSONUtils;
import com.ecgproject.commons.constants.Constants;
import com.ecgproject.commons.domain.ReturnObject;
import com.ecgproject.commons.utils.*;
import com.ecgproject.settings.domain.User;
import com.ecgproject.workbench.domain.Ecg;
import com.ecgproject.workbench.domain.Patient;
import com.ecgproject.workbench.service.EcgService;
import com.ecgproject.workbench.service.PatientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.*;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class EcgController {

    @Autowired
    private EcgService ecgService;

    @Autowired
    private PatientService patientService;

    @RequestMapping("/workbench/ecg/index.do")
    public String index(HttpServletRequest request){

        //搜所有的患者
        List<Patient> patientList = patientService.queryAllPatients();
        request.setAttribute("patientList", patientList);

        return "workbench/ecg/index";
    }


    /**
     * 测试用的 可以删掉
     * @param patientId
     * @param myFile
     * @return
     * @throws IOException
     */
    @RequestMapping("/workbench/ecg/fileUpload.do")
    public @ResponseBody Object fileUpload(String patientId, MultipartFile myFile) throws IOException {
        System.out.println(patientId);
        //把文件在服务器指定的目录中生成一个同样的文件，文件可以不存在，路径必须有
        File file = new File("D:\\24.毕业论文\\文档汇总\\targettest");
        myFile.transferTo(file);

        //返回响应信息
        ReturnObject returnObject = new ReturnObject();
        returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        returnObject.setMessage("上传成功");
        return  returnObject;
    }

    /**
     * 根据xml文件生成图片
     * @param ecgId
     * @return
     */
    @RequestMapping("/workbench/ecg/showEcgById2.do")
    public @ResponseBody byte[] showEcgById(String ecgId){
        Ecg ecg = ecgService.queryEcgById(ecgId);
        //获得后台服务器存着该文件的地址
        String ecgUrl = ecg.getEcgUrl();

        AnalysisHL7Utils analysisHL7Utils = new AnalysisHL7Utils();
        Map map1 = analysisHL7Utils.analysisHL7(ecgUrl);

        DrawECGUtils drawECGUtils = new DrawECGUtils();
        byte[] image = drawECGUtils.drawEcg(map1);
        //Desktop.getDesktop().open(new File("E:\\IDEA\\ecggraduation\\ECGToolkit\\ECGViewer.exe"));
        //returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        //String string = JSONUtils.toJSONString(image);

        return image;
    }

    @RequestMapping("/workbench/ecg/queryEcgById.do")
    public @ResponseBody Object queryEcgById(String ecgId){
        Ecg ecg = ecgService.queryEcgById(ecgId);
        String ecgUrl = ecg.getEcgUrl();
        AnalysisHL7Utils analysisHL7Utils = new AnalysisHL7Utils();
        Map map = analysisHL7Utils.analysisHL7(ecgUrl);

        Map<String,Object> mapres = new HashMap<>();
        DateUtils dateUtils = new DateUtils();
        String taketime = dateUtils.formateForHl7((String)map.get("taketime"));
        mapres.put("EcgTakeTime",taketime);
        return mapres;
    }

    @RequestMapping("/workbench/ecg/deleteEcgById.do")
    public @ResponseBody Object deleteEcgById(String ecgId){
        ReturnObject returnObject = new ReturnObject();
        int ret = ecgService.deleteEcgById(ecgId);

        if(ret>0){
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        }else{
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙碌，请稍后重试……");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/ecg/showEcgById.do")
    public void ShowImg(String ecgId, HttpServletRequest request, HttpServletResponse response) throws IOException{

        Ecg ecg = ecgService.queryEcgById(ecgId);
        //获得后台服务器存着该文件的地址
        String ecgUrl = ecg.getEcgUrl();

        AnalysisHL7Utils analysisHL7Utils = new AnalysisHL7Utils();
        Map map1 = analysisHL7Utils.analysisHL7(ecgUrl);

        DrawECGUtils drawECGUtils = new DrawECGUtils();
        byte[] image = drawECGUtils.drawEcg(map1);

        OutputStream outStream = null;
        try {

            response.setContentType("image/*");
            //得到向客户端输出二进制数据的对象
            outStream=response.getOutputStream();
            //输出数据
            outStream.write(image);
            outStream.flush();
        } catch (Exception e) {

            return;
        }finally {
            //关闭输出流
            outStream.close();

        }
    }



    @RequestMapping("/workbench/ecg/queryEcgByConditionForPage.do")
    public @ResponseBody Object queryEcgByConditionForPage(String patientId,int pageNo,int pageSize){
        //封装
        Map<String,Object> map = new HashMap<>();
        map.put("patientId",patientId);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        //调service查数据
        List<Ecg> ecgList = ecgService.queryEcgByConditionForPage(map);
        int totalRows = ecgService.queryCountOfEcgByCondition(map);

        //根据查询结果生成相应信息
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("ecgList",ecgList);
        retMap.put("totalRows",totalRows);

        return retMap;

    }

    @RequestMapping("/workbench/ecg/importEcg.do")
    public @ResponseBody Object importEcg(MultipartFile ecgFile, String patientId, HttpSession session) throws IOException {
        User user = (User)session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        try{
            UUIDUtils uuidUtils = new UUIDUtils();
            String ecgId = uuidUtils.getUUID();
            String originalFilename = ecgId+".XML";
            File file = new File("E:\\IDEA\\ecggraduation\\Server\\",originalFilename);
            String ecgUrl = "E:\\IDEA\\ecggraduation\\Server\\" + originalFilename;
            ecgFile.transferTo(file);

            Ecg ecg = new Ecg();
            ecg.setEcgId(ecgId);
            ecg.setEcgUrl(ecgUrl);
            ecg.setEcgUploader(user.getUserId());
            ecg.setEcgPatient(patientId);

            DateUtils dateUtils = new DateUtils();
            Date date = new Date();
            String ecgUploadtime = dateUtils.formateDateTime(date);
            ecg.setEcgUploadtime(ecgUploadtime);

            int ret = ecgService.saveImportEcg(ecg);

            if(ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙碌，请稍后重试……");
            }
        }catch(Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙碌，请稍后重试……");
        }

        return returnObject;

    }

}
