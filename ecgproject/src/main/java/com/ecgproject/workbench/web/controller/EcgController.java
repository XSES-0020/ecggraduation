package com.ecgproject.workbench.web.controller;

import com.ecgproject.commons.constants.Constants;
import com.ecgproject.commons.domain.ReturnObject;
import com.ecgproject.commons.utils.*;
import com.ecgproject.settings.domain.User;
import com.ecgproject.workbench.domain.Ecg;
import com.ecgproject.workbench.domain.Patient;
import com.ecgproject.workbench.service.EcgService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.awt.*;
import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class EcgController {

    @Autowired
    private EcgService ecgService;

    @RequestMapping("/workbench/ecg/index.do")
    public String index(){
        return "workbench/ecg/index";
    }

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

    @RequestMapping("/workbench/ecg/showEcgById.do")
    public @ResponseBody Object showEcgById(){
        ReturnObject returnObject = new ReturnObject();
        //MouseUtils mouseUtils = new MouseUtils();
        try{
            AnalysisHL7Utils analysisHL7Utils = new AnalysisHL7Utils();
            Map map = analysisHL7Utils.analysisHL7();
            DrawECGUtils drawECGUtils = new DrawECGUtils();
            drawECGUtils.drawEcg(map);
            //Desktop.getDesktop().open(new File("E:\\IDEA\\ecggraduation\\ECGToolkit\\ECGViewer.exe"));
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙碌，请稍后重试……");
        }
        return returnObject;
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
