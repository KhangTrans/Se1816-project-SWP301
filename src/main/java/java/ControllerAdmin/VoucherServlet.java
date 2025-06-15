package ControllerAdmin;

import DAO.VoucherDao;
import Model.Voucher;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "VoucherServlet", urlPatterns = {"/admin/vouchers"})
public class VoucherServlet extends HttpServlet {

    private final VoucherDao voucherDao = new VoucherDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("ajaxList".equals(action)) {
                List<Voucher> vouchers = voucherDao.getAllVouchers();
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                Gson gson = new GsonBuilder()
                        .registerTypeAdapter(LocalDate.class, new JsonSerializer<LocalDate>() {
                            @Override
                            public JsonElement serialize(LocalDate src, java.lang.reflect.Type typeOfSrc, JsonSerializationContext context) {
                                return new JsonPrimitive(src.toString()); // ISO: "yyyy-MM-dd"
                            }
                        })
                        .create();

                String json = gson.toJson(vouchers);
                response.getWriter().write(json);
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Voucher voucher = voucherDao.getVoucherById(id);
                if (voucher == null) {
                    response.sendError(404, "Voucher not found");
                    return;
                }
                request.setAttribute("voucher", voucher);
                request.getRequestDispatcher("/WEB-INF/View/admin/vouchers/edit.jsp").forward(request, response);

            } else {
                List<Voucher> vouchers = voucherDao.getAllVouchers();
                request.setAttribute("vouchers", vouchers);
                request.getRequestDispatcher("/WEB-INF/View/admin/vouchers/list.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Internal Server Error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String formAction = request.getParameter("formAction");
        System.out.println("formAction: " + formAction); // Log giá trị formAction
        if (formAction == null || formAction.isEmpty()) {
            response.setStatus(400);
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Thiếu formAction.\"}");
            return;
        }

        try {
            switch (formAction) {
                case "create":
                    Voucher newVoucher = parseVoucherFromRequest(request);
                    voucherDao.createVoucher(newVoucher);

                    // Log dữ liệu trả về
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    Gson gson = new Gson();
                    String jsonResponse = gson.toJson(newVoucher); // Trả lại toàn bộ voucher mới tạo
                    System.out.println("Dữ liệu voucher trả về: " + jsonResponse); // Log dữ liệu

                    response.getWriter().write("{\"status\":\"created\",\"message\":\"Voucher created successfully!\"}");
                    break;
                case "update":
                    Voucher updatedVoucher = parseVoucherFromRequest(request);
                    int updateId = Integer.parseInt(request.getParameter("voucherId"));
                    updatedVoucher.setVoucherId(updateId);
                    voucherDao.updateVoucher(updatedVoucher);
                    response.getWriter().write("{\"status\":\"updated\",\"message\":\"Voucher updated successfully!\"}");
                    break;

                case "delete":
                    String idStr = request.getParameter("voucherId");
                    if (idStr == null || idStr.isEmpty()) {
                        response.setStatus(400);
                        response.getWriter().write("{\"status\":\"error\",\"message\":\"Thiếu voucherId.\"}");
                        return;
                    }

                    int deleteId = Integer.parseInt(idStr);
                    boolean deleted = voucherDao.deleteVoucher(deleteId);
                    if (deleted) {
                        response.getWriter().write("{\"status\":\"deleted\",\"message\":\"Voucher deleted successfully!\"}");
                    } else {
                        response.setStatus(404);
                        response.getWriter().write("{\"status\":\"error\",\"message\":\"Không tìm thấy voucher để xóa.\"}");
                    }
                    break;

                default:
                    response.setStatus(400);
                    response.getWriter().write("{\"status\":\"error\",\"message\":\"Hành động không hợp lệ.\"}");
                    break;
            }

        } catch (NumberFormatException e) {
            response.setStatus(400);
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Định dạng số không hợp lệ.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"status\":\"error\",\"message\":\"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    private Voucher parseVoucherFromRequest(HttpServletRequest request) throws Exception {
        Voucher voucher = new Voucher();

        String code = request.getParameter("code");
        String description = request.getParameter("description");
        String discountPercentStr = request.getParameter("discountPercent");
        String maxDiscountStr = request.getParameter("maxDiscount");
        String usageLimitStr = request.getParameter("usageLimit");
        String usedCountStr = request.getParameter("usedCount");
        String minOrderAmountStr = request.getParameter("minOrderAmount");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String isActiveStr = request.getParameter("isActive");

        if (code == null || description == null || discountPercentStr == null || maxDiscountStr == null
                || usageLimitStr == null || usedCountStr == null || minOrderAmountStr == null || startDateStr == null || endDateStr == null) {
            throw new IllegalArgumentException("Dữ liệu không hợp lệ: Thiếu thông tin bắt buộc.");
        }

        voucher.setCode(code);
        voucher.setDescription(description);
        voucher.setDiscountPercent(Integer.parseInt(discountPercentStr));
        voucher.setMaxDiscount(new BigDecimal(maxDiscountStr));
        voucher.setUsageLimit(Integer.parseInt(usageLimitStr));
        voucher.setUsedCount(Integer.parseInt(usedCountStr));
        voucher.setMinOrderAmount(new BigDecimal(minOrderAmountStr));
        voucher.setStartDate(LocalDate.parse(startDateStr));
        voucher.setEndDate(LocalDate.parse(endDateStr));
        voucher.setActive("1".equals(isActiveStr)); // true nếu là "1", false nếu khác

        return voucher;
    }

    @Override
    public String getServletInfo() {
        return "Handles CRUD operations for vouchers";
    }
}
