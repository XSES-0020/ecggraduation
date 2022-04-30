package com.ecgproject.commons.utils;

import java.awt.Toolkit;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.StringSelection;
import java.awt.event.InputEvent;
import java.awt.event.KeyEvent;
import java.awt.image.BufferedImage;
import java.io.File;
import javax.imageio.ImageIO;
import java.awt.AWTException;
import java.awt.Dimension;
import java.awt.Rectangle;
import java.awt.Robot;

public class MouseUtils {
    private static Robot robot;

    static {
        try {
            robot = new Robot();
            // 执行完一个事件后，再执行下一个
            robot.setAutoWaitForIdle(true);
        } catch (AWTException e) {
            e.printStackTrace();
        }
    }

    /***
     * @date 2020年4月8日 下午11:52:22
     * @Title: inputStr
     * @Description: 输入字符串；
     * @param str 带输入的字符串
     */

    public static void inputStr(String str) {// 字符串
        robot.delay(1000);// 等待1秒
        Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
        clipboard.setContents(new StringSelection(str), null);
        robot.keyPress(KeyEvent.VK_CONTROL);
        robot.keyPress(KeyEvent.VK_V);
        robot.keyRelease(KeyEvent.VK_V);
        robot.keyRelease(KeyEvent.VK_CONTROL);
        System.out.println("输入字符串【" + str + "】完毕");
    }

    public static void delay(){
        robot.delay(2000);
    }

    /***
     * 鼠标移动到某个坐标点；
     */

    public static void moveTo(int x, int y) {
        robot.delay(1000);// 等待1秒
        //将鼠标指针移动到指定屏幕坐标
        robot.mouseMove(x, y);
        System.out.println("鼠标移动到【" + x + "," + y + "】坐标点完毕");
    }

    /***
     *
     * 按下/释放一个或多个鼠标按钮, 参数说明:
     * buttons: 鼠标按钮掩码, 一个或多个以下标志的组合:
     * InputEvent.BUTTON1_MASK 鼠标左键
     * InputEvent.BUTTON2_MASK 鼠标中键
     * InputEvent.BUTTON3_MASK 鼠标右键
     */

    public static void mousePress(int type) {
        robot.delay(1000);// 等待1秒
        if (type == 1)
            robot.mousePress(InputEvent.BUTTON1_MASK);// 鼠标左键
        if (type == 2)
            robot.mousePress(InputEvent.BUTTON2_MASK);// 鼠标中键
        if (type == 3)
            robot.mousePress(InputEvent.BUTTON3_MASK);// 鼠标右键

        System.out.println("【" + (type == 1 ? "按下鼠标左键" : type == 2 ? "按下鼠标中键" : "按下鼠标右键") + "】完毕");
    }

    /***
     * 释放鼠标左键(按下后必须要释放, 一次点击操作包含：按下和释放)
     * @date 2020年4月9日 上午12:07:47
     */

    public static void mouseRelease(int buttons) {
        robot.delay(1000);// 等待1秒
        if (buttons == 1)
            robot.mouseRelease(InputEvent.BUTTON1_MASK);// 鼠标左键
        if (buttons == 2)
            robot.mouseRelease(InputEvent.BUTTON2_MASK);// 鼠标中键
        if (buttons == 3)
            robot.mouseRelease(InputEvent.BUTTON3_MASK);// 鼠标右键

        System.out.println("【" + (buttons == 1 ? "松开鼠标左键" : buttons == 2 ? "松开鼠标中键" : "松开鼠标右键") + "】完毕");
    }

    /***
     * 截屏；从X、Y坐标点，截取宽度为imageWidth，高为imageHeight的图像；
     * @param imageFilePath 图片保存路径(全路径；)；
     * @param X 截屏开始X轴坐标点；
     * @param Y 截屏开始Y轴坐标点；
     * @param imageWidth 从X坐标点开始的X轴长度；
     * @param imageHeight 从Y坐标点开始Y轴的高度；
     * @return void 返回类型
     */

    public static void snapShot(String imageFilePath, int X, int Y, int imageWidth, int imageHeight) {

        try { // 拷贝屏幕到一个BufferedImage对象screenshot
            BufferedImage screenshot = robot.createScreenCapture(new Rectangle(100, 100, 400, 100));
            File f = new File(imageFilePath);
            System.out.print("Save File " + imageFilePath + ""); // 将screenshot对象写入图像文件
            ImageIO.write(screenshot, "png", f);
            System.out.print("......Finished!\n");
        } catch (Exception ex) {
            System.out.println(ex);
        }
    }
}
